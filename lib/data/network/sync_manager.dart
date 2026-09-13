import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:offline_cart/data/local/database/app_database.dart';
import 'package:offline_cart/data/network/dio_client.dart';

class SyncManager extends GetxController {
  final AppDatabase _db;
  final Dio _dio;
  final InternetConnection _connection;

  SyncManager({AppDatabase? database, Dio? dio, InternetConnection? connection})
    : _db = database ?? AppDatabase.instance,
      _dio = dio ?? DioClient.instance.dio,
      _connection = connection ?? InternetConnection();

  final isOnline = true.obs;
  final isSyncing = false.obs;
  final currentSyncItem = ''.obs;
  final currentItemIndex = 0.obs;
  final totalItemsToSync = 0.obs;
  final syncProgress = 0.0.obs;
  final pendingRequests = <PendingRequestsTableData>[].obs;
  final pendingCount = 0.obs;
  final lastSyncTime = Rxn<DateTime>();
  final justFinishedSync = false.obs;

  StreamSubscription<InternetStatus>? _connectionSub;
  StreamSubscription<List<PendingRequestsTableData>>? _queueSub;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _startListening();
  }

  Future<void> _checkInitialConnection() async {
    final connected = await _connection.hasInternetAccess;
    isOnline.value = connected;
    if (connected) {
      // Trigger sync if there are leftover pending requests on app launch
      syncPendingRequests();
    }
  }

  void _startListening() {
    _connectionSub = _connection.onStatusChange.listen((status) {
      final connected = status == InternetStatus.connected;
      final wasOffline = !isOnline.value;
      isOnline.value = connected;

      // When transitioning from offline to online, auto-sync pending table
      if (connected && wasOffline) {
        debugPrint('[SyncManager] Internet restored. Starting auto-sync...');
        syncPendingRequests();
      }
    });

    _queueSub = _db.pendingRequestsDao.watchPendingRequests().listen((items) {
      pendingRequests.value = items;
      pendingCount.value = items.where((i) => i.status != 'synced').length;
    });
  }

  /// Automatically or manually syncs all pending requests from Drift table
  Future<void> syncPendingRequests() async {
    if (isSyncing.value) return;

    final hasInternet = await _connection.hasInternetAccess;
    if (!hasInternet) {
      isOnline.value = false;
      return;
    }

    final requests = await _db.pendingRequestsDao.getPendingRequests();
    if (requests.isEmpty) return;

    isSyncing.value = true;
    syncProgress.value = 0.0;
    totalItemsToSync.value = requests.length;

    for (int i = 0; i < requests.length; i++) {
      final req = requests[i];
      currentItemIndex.value = i + 1;
      currentSyncItem.value = req.description;
      syncProgress.value = (i) / requests.length;

      await _db.pendingRequestsDao.updateStatus(req.id, 'syncing');

      try {
        dynamic requestData;
        if (req.body != null && req.body!.isNotEmpty) {
          try {
            requestData = jsonDecode(req.body!);
          } catch (_) {
            requestData = req.body;
          }
        }

        Map<String, dynamic>? queryParams;
        if (req.queryParams != null && req.queryParams!.isNotEmpty) {
          try {
            queryParams = jsonDecode(req.queryParams!) as Map<String, dynamic>?;
          } catch (_) {}
        }

        Map<String, dynamic>? headers;
        if (req.headers != null && req.headers!.isNotEmpty) {
          try {
            headers = jsonDecode(req.headers!) as Map<String, dynamic>?;
          } catch (_) {}
        }

        // Replay the request with skip_offline_interceptor: true
        final response = await _dio.request(
          req.url,
          data: requestData,
          queryParameters: queryParams,
          options: Options(
            method: req.method,
            headers: headers,
            extra: {'skip_offline_interceptor': true},
          ),
        );

        final statusCode = response.statusCode ?? 500;
        if (statusCode >= 200 && statusCode < 300) {
          // Success: delete processed item from Drift table
          await _db.pendingRequestsDao.deleteRequest(req.id);
        } else {
          await _db.pendingRequestsDao.incrementRetry(req.id, req.retryCount);
        }
      } on DioException {
        final stillOnline = await _connection.hasInternetAccess;
        if (!stillOnline) {
          isOnline.value = false;
          await _db.pendingRequestsDao.updateStatus(req.id, 'pending');
          break; // Stop syncing remaining items until internet returns
        }

        // If exceeded retries, discard or keep failed
        if (req.retryCount >= 3) {
          await _db.pendingRequestsDao.deleteRequest(req.id);
        } else {
          await _db.pendingRequestsDao.incrementRetry(req.id, req.retryCount);
        }
      } catch (e) {
        debugPrint('[SyncManager] Error syncing item ${req.id}: $e');
        if (req.retryCount >= 3) {
          await _db.pendingRequestsDao.deleteRequest(req.id);
        } else {
          await _db.pendingRequestsDao.incrementRetry(req.id, req.retryCount);
        }
      }
    }

    syncProgress.value = 1.0;
    isSyncing.value = false;
    currentSyncItem.value = '';
    lastSyncTime.value = DateTime.now();

    // Show temporary completion pulse
    justFinishedSync.value = true;
    Future.delayed(const Duration(seconds: 4), () {
      justFinishedSync.value = false;
    });
  }

  Future<void> clearQueue() async {
    await _db.pendingRequestsDao.clearAll();
  }

  @override
  void onClose() {
    _connectionSub?.cancel();
    _queueSub?.cancel();
    super.onClose();
  }
}
