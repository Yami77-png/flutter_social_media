import 'package:dio/dio.dart';

class DioHelper {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://ron-swanson-quotes.herokuapp.com/v2', // You can override this per request
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // GET request
  static Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? headers,
    String? overrideBaseUrl,
  }) async {
    try {
      if (overrideBaseUrl != null) {
        _dio.options.baseUrl = overrideBaseUrl;
      }

      final response = await _dio.get(path, queryParameters: queryParams, options: Options(headers: headers));
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  static Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    String? overrideBaseUrl,
  }) async {
    try {
      if (overrideBaseUrl != null) {
        _dio.options.baseUrl = overrideBaseUrl;
      }

      final response = await _dio.post(path, data: data, options: Options(headers: headers));
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  static Future<dynamic> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    String? overrideBaseUrl,
  }) async {
    try {
      if (overrideBaseUrl != null) {
        _dio.options.baseUrl = overrideBaseUrl;
      }

      final response = await _dio.put(path, data: data, options: Options(headers: headers));
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  static Future<dynamic> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? headers,
    String? overrideBaseUrl,
  }) async {
    try {
      if (overrideBaseUrl != null) {
        _dio.options.baseUrl = overrideBaseUrl;
      }

      final response = await _dio.delete(path, data: data, options: Options(headers: headers));
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
