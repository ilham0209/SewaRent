import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../constants/app_constants.dart';
import '../storage/token_storage.dart';
import 'api_exception.dart';
import 'api_response.dart';

class ApiClient {
  ApiClient({required this.tokenStorage, http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  static const _timeout = Duration(seconds: 30);
  static const _jsonContentType = 'application/json';

  final TokenStorage tokenStorage;
  final http.Client _httpClient;

  Uri _uri(String path, {Map<String, String>? queryParameters}) {
    final base = AppConstants.apiBaseUrl.endsWith('/')
        ? AppConstants.apiBaseUrl.substring(0, AppConstants.apiBaseUrl.length - 1)
        : AppConstants.apiBaseUrl;
    final subPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('$base$subPath');
    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }
    return uri.replace(queryParameters: queryParameters);
  }

  Future<Map<String, String>> _headers({required bool authRequired}) async {
    final headers = <String, String>{'Accept': _jsonContentType};
    if (!authRequired) {
      return headers;
    }
    final token = await tokenStorage.readAccessToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  Future<T?> get<T>(
    String path, {
    Map<String, String>? queryParameters,
    bool authRequired = true,
    required T Function(Object? data) dataParser,
  }) {
    return _send<T>(() async {
      final uri = _uri(path, queryParameters: queryParameters);
      final headers = await _headers(authRequired: authRequired);
      return _httpClient.get(uri, headers: headers);
    }, dataParser);
  }

  Future<T?> post<T>(
    String path, {
    Map<String, dynamic>? body,
    bool authRequired = true,
    required T Function(Object? data) dataParser,
  }) {
    return _send<T>(() async {
      final uri = _uri(path);
      final headers = await _headers(authRequired: authRequired);
      if (body != null) {
        headers['Content-Type'] = _jsonContentType;
      }
      return _httpClient.post(
        uri,
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      );
    }, dataParser);
  }

  Future<T?> put<T>(
    String path, {
    Map<String, dynamic>? body,
    bool authRequired = true,
    required T Function(Object? data) dataParser,
  }) {
    return _send<T>(() async {
      final uri = _uri(path);
      final headers = await _headers(authRequired: authRequired);
      if (body != null) {
        headers['Content-Type'] = _jsonContentType;
      }
      return _httpClient.put(
        uri,
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      );
    }, dataParser);
  }

  Future<T?> delete<T>(
    String path, {
    Map<String, dynamic>? body,
    bool authRequired = true,
    required T Function(Object? data) dataParser,
  }) {
    return _send<T>(() async {
      final uri = _uri(path);
      final headers = await _headers(authRequired: authRequired);
      if (body != null) {
        headers['Content-Type'] = _jsonContentType;
      }
      return _httpClient.delete(
        uri,
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      );
    }, dataParser);
  }

  Future<T?> postMultipart<T>(
    String path, {
    required String field,
    required List<int> bytes,
    required String filename,
    Map<String, String>? fields,
    bool authRequired = true,
    required T Function(Object? data) dataParser,
  }) {
    return _send<T>(() async {
      final uri = _uri(path);
      final request = http.MultipartRequest('POST', uri)
        ..headers.addAll(await _headers(authRequired: authRequired));
      if (fields != null) {
        request.fields.addAll(fields);
      }
      request.files.add(
        http.MultipartFile.fromBytes(
          field,
          bytes,
          filename: filename,
          contentType: MediaType(
            'image',
            filename.split('.').last.toLowerCase(),
          ),
        ),
      );
      final streamed = await _httpClient.send(request);
      return http.Response.fromStream(streamed);
    }, dataParser);
  }

  Future<T?> _send<T>(
    Future<http.Response> Function() request,
    T Function(Object? data) dataParser,
  ) async {
    try {
      final response = await request().timeout(_timeout);
      return _decode(response, dataParser);
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(
        type: ApiErrorType.timeout,
        message: 'The request timed out. Please try again.',
      );
    } on http.ClientException {
      throw const ApiException(
        type: ApiErrorType.network,
        message: 'Unable to reach the server. Please check your connection.',
      );
    } on FormatException {
      throw const ApiException(
        type: ApiErrorType.unknown,
        message: 'The server returned an unexpected response.',
      );
    } catch (error) {
      throw ApiException(type: ApiErrorType.unknown, message: error.toString());
    }
  }

  T? _decode<T>(http.Response response, T Function(Object? data) dataParser) {
    final body = utf8.decode(response.bodyBytes);
    Object? decoded;
    if (body.isNotEmpty) {
      try {
        decoded = jsonDecode(body);
      } on FormatException {
        decoded = null;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (decoded == null) {
        return null;
      }
      if (decoded is Map<String, dynamic>) {
        final isEnvelope =
            decoded.containsKey('success') ||
            decoded.containsKey('data') ||
            decoded.containsKey('errors');
        if (isEnvelope) {
          final parsed = ApiResponse<T>.fromJson(
            decoded,
            dataParser: dataParser,
          );
          return parsed.data;
        }
        return dataParser(decoded);
      }
      return dataParser(decoded);
    }

    throw _toApiException(
      response.statusCode,
      decoded is Map<String, dynamic> ? decoded : null,
    );
  }

  ApiException _toApiException(int statusCode, Map<String, dynamic>? envelope) {
    String? message;
    final errors = <ApiFieldError>[];
    if (envelope != null) {
      message = envelope['message']?.toString() ??
          envelope['detailed']?.toString() ??
          envelope['detail']?.toString() ??
          envelope['title']?.toString();
      final rawErrors = envelope['errors'];
      if (rawErrors is List) {
        for (final error in rawErrors) {
          if (error is Map<String, dynamic>) {
            errors.add(
              ApiFieldError(
                field: error['field']?.toString() ?? '',
                message: error['message']?.toString() ?? '',
              ),
            );
          }
        }
      } else if (rawErrors is Map<String, dynamic>) {
        for (final entry in rawErrors.entries) {
          final val = entry.value;
          if (val is List) {
            for (final msg in val) {
              errors.add(
                ApiFieldError(field: entry.key, message: msg.toString()),
              );
            }
          } else if (val != null) {
            errors.add(
              ApiFieldError(field: entry.key, message: val.toString()),
            );
          }
        }
      }
    }

    if ((message == null || message.isEmpty) && errors.isNotEmpty) {
      message = errors.map((e) => e.message).join('\n');
    }

    return ApiException(
      type: _errorTypeForStatus(statusCode),
      statusCode: statusCode,
      message:
          message ??
          'Request failed with status code $statusCode. Please try again.',
      errors: errors,
    );
  }

  ApiErrorType _errorTypeForStatus(int statusCode) {
    switch (statusCode) {
      case 400:
        return ApiErrorType.badRequest;
      case 401:
        return ApiErrorType.unauthorized;
      case 403:
        return ApiErrorType.forbidden;
      case 404:
        return ApiErrorType.notFound;
      case 409:
        return ApiErrorType.conflict;
      case 422:
        return ApiErrorType.validation;
      default:
        if (statusCode >= 500) {
          return ApiErrorType.server;
        }
        return ApiErrorType.unknown;
    }
  }
}
