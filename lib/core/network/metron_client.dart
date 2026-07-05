import 'dart:convert';
import 'package:dio/dio.dart';
import '../config/env.dart';

const _baseUrl = 'https://metron.cloud/api/';

/// interceptor de autenticação basic auth para a api metron.
class _MetronAuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final credentials = base64Encode(
      utf8.encode('${Env.metronUsername}:${Env.metronPassword}'),
    );
    options.headers['Authorization'] = 'Basic $credentials';
    super.onRequest(options, handler);
  }
}

/// interceptor de rate limit: lê os headers devolvidos pela api metron e atrasa pedidos futuros se necessário.
class _RateLimitInterceptor extends Interceptor {
  int? _burstRemainingRequests;
  DateTime? _burstResetTime;
  int? _sustainedRemainingRequests;
  DateTime? _sustainedResetTime;

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _burstRemainingRequests =
        _parseRemaining(
          response.headers.value('X-RateLimit-Burst-Remaining'),
        ) ??
        _burstRemainingRequests;
    _burstResetTime =
        _parseResetTime(response.headers.value('X-RateLimit-Burst-Reset')) ??
        _burstResetTime;
    _sustainedRemainingRequests =
        _parseRemaining(
          response.headers.value('X-RateLimit-Sustained-Remaining'),
        ) ??
        _sustainedRemainingRequests;
    _sustainedResetTime =
        _parseResetTime(
          response.headers.value('X-RateLimit-Sustained-Reset'),
        ) ??
        _sustainedResetTime;

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 429) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: 'Rate limit atingido. Tente de novo em alguns segundos.',
          type: DioExceptionType.badResponse,
          response: err.response,
        ),
      );
      return;
    }
    super.onError(err, handler);
  }

  bool get isThrottled {
    final now = DateTime.now();
    return _isWindowThrottled(
          remainingRequests: _burstRemainingRequests,
          resetTime: _burstResetTime,
          now: now,
        ) ||
        _isWindowThrottled(
          remainingRequests: _sustainedRemainingRequests,
          resetTime: _sustainedResetTime,
          now: now,
        );
  }

  int? _parseRemaining(String? value) => int.tryParse(value ?? '');

  DateTime? _parseResetTime(String? value) {
    final resetEpoch = int.tryParse(value ?? '');
    if (resetEpoch == null) return null;

    return DateTime.fromMillisecondsSinceEpoch(resetEpoch * 1000);
  }

  bool _isWindowThrottled({
    required int? remainingRequests,
    required DateTime? resetTime,
    required DateTime now,
  }) =>
      remainingRequests != null &&
      remainingRequests <= 1 &&
      resetTime != null &&
      now.isBefore(resetTime);
}

/// cache em memória para evitar pedidos repetidos à api durante a sessão.
class MetronCache {
  final Map<String, dynamic> _store = {};

  T? get<T>(String key) => _store[key] as T?;
  void set(String key, dynamic value) => _store[key] = value;
  bool has(String key) => _store.containsKey(key);
  void invalidate(String key) => _store.remove(key);
}

Dio createMetronClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.addAll([
    _MetronAuthInterceptor(),
    _RateLimitInterceptor(),
    LogInterceptor(responseBody: false, requestBody: false),
  ]);

  return dio;
}
