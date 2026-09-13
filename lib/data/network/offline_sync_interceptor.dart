import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:offline_cart/data/local/database/app_database.dart';

/// Intercepts outgoing requests when offline, saving mutating requests to the
/// local Drift pending_requests table and completing optimistically.
class OfflineSyncInterceptor extends Interceptor {
  final AppDatabase _db;
  final InternetConnection _connection;

  OfflineSyncInterceptor({
    AppDatabase? database,
    InternetConnection? connection,
  }) : _db = database ?? AppDatabase.instance,
       _connection = connection ?? InternetConnection();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Skip if request is being replayed by SyncManager or explicitly bypassed
    if (options.extra['skip_offline_interceptor'] == true) {
      return handler.next(options);
    }

    // 2. Check if this request should be queued when offline
    // By default: mutating HTTP methods (POST, PUT, DELETE, PATCH) or explicit flag
    final isMutating = [
      'POST',
      'PUT',
      'DELETE',
      'PATCH',
    ].contains(options.method.toUpperCase());
    final shouldQueue = options.extra['queue_offline'] == true || isMutating;

    if (!shouldQueue) {
      return handler.next(options);
    }

    // 3. Verify actual network connectivity
    final hasInternet = await _connection.hasInternetAccess;
    if (hasInternet) {
      return handler.next(options);
    }

    // 4. Offline: persist request into Drift pending_requests table
    try {
      final description =
          options.extra['description'] as String? ??
          '${options.method.toUpperCase()} ${options.path}';

      String? bodyStr;
      if (options.data != null) {
        if (options.data is Map || options.data is List) {
          bodyStr = jsonEncode(options.data);
        } else {
          bodyStr = options.data.toString();
        }
      }

      String? queryParamsStr;
      if (options.queryParameters.isNotEmpty) {
        queryParamsStr = jsonEncode(options.queryParameters);
      }

      final serializableHeaders = <String, dynamic>{};
      options.headers.forEach((key, value) {
        if (value is String || value is num || value is bool) {
          serializableHeaders[key] = value;
        }
      });
      final headersStr = serializableHeaders.isNotEmpty
          ? jsonEncode(serializableHeaders)
          : null;

      await _db.pendingRequestsDao.insertRequest(
        PendingRequestsTableCompanion.insert(
          url: options.path,
          method: options.method.toUpperCase(),
          headers: Value(headersStr),
          body: Value(bodyStr),
          queryParams: Value(queryParamsStr),
          description: Value(description),
        ),
      );

      // 5. Resolve optimistically with 202 Accepted so caller UI does not fail
      return handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 202,
          data: {
            'offline': true,
            'queued': true,
            'message': 'Saved offline. Will sync when back online.',
            if (options.extra['offline_fallback_data'] is Map<String, dynamic>)
              ...(options.extra['offline_fallback_data']
                  as Map<String, dynamic>),
          },
          statusMessage: 'Offline: Queued for sync',
        ),
      );
    } catch (e) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'Failed to queue offline request: $e',
          type: DioExceptionType.connectionError,
        ),
      );
    }
  }
}
