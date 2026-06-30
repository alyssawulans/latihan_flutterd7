import 'package:dio/dio.dart';
import 'package:latihan_flutterd7/day_36/services/token_storage.dart';

Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://appabsensi.mobileprojp.com',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ), // BaseOptions
  ); // Dio

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final path = options.path;
        final isPublicRoute = path.contains('/api/login') ||
            path.contains('/api/register') ||
            path.contains('/api/batches') ||
            path.contains('/api/trainings');
        
        if (!isPublicRoute) {
          final token = await TokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        handler.next(options);
      },
    ),
  );

  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  return dio;
}
