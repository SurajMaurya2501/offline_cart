import 'package:dio/dio.dart';
import 'package:offline_cart/data/network/offline_sync_interceptor.dart';

class DioClient {
  static DioClient? _instance;
  late final Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com/',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(OfflineSyncInterceptor());
  }

  static DioClient get instance => _instance ??= DioClient._internal();
}
