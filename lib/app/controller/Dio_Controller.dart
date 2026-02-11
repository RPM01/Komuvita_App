import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

//String baseUrl = 'http://api.komuvita.com';
String baseUrl = 'https://apidesa.komuvita.com';

class ApiClient {

  // The single shared Dio instance
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://apidesa.komuvita.com/',
      //baseUrl: 'http://api.komuvita.com/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept-Encoding': 'gzip, deflate',
      },
    ),
  );

  // Call this once in main() to setup interceptors and logging
  static void initialize() {
    debugPrint("era yo DIO!!!!");
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.extra['start_time'] = DateTime.now();
          debugPrint('➡️ [${options.method}] ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          final start = response.requestOptions.extra['start_time'] as DateTime?;
          if (start != null) {
            final elapsed = DateTime.now().difference(start).inMilliseconds;
            debugPrint('⏱ ${response.requestOptions.uri} took ${elapsed} ms');
          }
          debugPrint('⬅️ [${response.statusCode}] ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (err, handler) {
          final start = err.requestOptions.extra['start_time'] as DateTime?;
          if (start != null) {
            final elapsed = DateTime.now().difference(start).inMilliseconds;
            debugPrint('⏱ ERROR after ${elapsed} ms');
          }
          debugPrint('❌ ${err.message}');
          return handler.next(err);
        },
      ),
    );
  }
}
