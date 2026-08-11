import 'api_exception.dart';

class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.errors = const [],
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    required T Function(Object? data) dataParser,
  }) {
    final errors = <ApiFieldError>[];
    final rawErrors = json['errors'];
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
    }

    return ApiResponse<T>(
      success: json['success'] == true,
      message: json['message']?.toString(),
      data: json['data'] == null ? null : dataParser(json['data']),
      errors: errors,
    );
  }

  final bool success;
  final String? message;
  final T? data;
  final List<ApiFieldError> errors;
}
