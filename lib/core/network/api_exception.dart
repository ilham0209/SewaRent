enum ApiErrorType {
  network,
  timeout,
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  validation,
  server,
  unknown,
}

class ApiException implements Exception {
  const ApiException({
    required this.type,
    this.statusCode,
    this.message,
    this.errors = const [],
  });

  final ApiErrorType type;
  final int? statusCode;
  final String? message;
  final List<ApiFieldError> errors;

  @override
  String toString() =>
      'ApiException(type: $type, statusCode: $statusCode, message: $message)';
}

class ApiFieldError {
  const ApiFieldError({required this.field, required this.message});

  final String field;
  final String message;
}
