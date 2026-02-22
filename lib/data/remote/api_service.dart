import 'package:dio/dio.dart';
import 'package:family_budget/core/config/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  late final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  static const _tokenKey = 'auth_token';

  ApiService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ));

    // Inject JWT token on every request
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secureStorage.read(key: _tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        // Surface clean error messages
        final response = error.response;
        if (response != null) {
          final body = response.data;
          final message = body is Map ? body['message'] ?? error.message : error.message;
          handler.reject(DioException(
            requestOptions: error.requestOptions,
            response: response,
            error: ApiException(message?.toString() ?? 'Unknown error', response.statusCode),
          ));
        } else {
          handler.reject(DioException(
            requestOptions: error.requestOptions,
            error: ApiException('Network error. Please check your connection.', null),
          ));
        }
      },
    ));
  }

  // === Token management ===

  Future<void> saveToken(String token) =>
      _secureStorage.write(key: _tokenKey, value: token);

  Future<void> clearToken() => _secureStorage.delete(key: _tokenKey);

  Future<bool> hasToken() async =>
      (await _secureStorage.read(key: _tokenKey)) != null;

  // === HTTP helpers ===

  Future<T> get<T>(String path, {Map<String, dynamic>? queryParams,
      required T Function(dynamic) fromJson}) async {
    final response = await _dio.get(path, queryParameters: queryParams);
    return fromJson(response.data);
  }

  Future<T> post<T>(String path, {required dynamic body,
      required T Function(dynamic) fromJson}) async {
    final response = await _dio.post(path, data: body);
    return fromJson(response.data);
  }

  Future<T> put<T>(String path, {required dynamic body,
      required T Function(dynamic) fromJson}) async {
    final response = await _dio.put(path, data: body);
    return fromJson(response.data);
  }

  Future<void> delete(String path) async {
    await _dio.delete(path);
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}
