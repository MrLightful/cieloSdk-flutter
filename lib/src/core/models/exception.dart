/// Exception thrown when the Cielo API returns an error.
class CieloAPIException implements Exception {

  /// HTTP status code from the error response.
  final int code;

  /// Error message from the error response (`reasonPhrase`).
  final String? message;

  CieloAPIException({
    required this.code,
    this.message = '',
  });

  @override
  String toString() => '[CieloAPIException] $code - $message';
}

/// Exception thrown for validation errors caught before making the request to Cielo API.
class CieloException implements Exception {

  /// Field name that failed validation.
  final String field;

  /// Error code to identify the validation problem.
  final String code;

  /// Elaborate error message for developer.
  final String? message;

  CieloException({
    required this.field,
    required this.code,
    this.message,
  });

  @override
  String toString() => '[CieloValidationException] $field - $code - $message';
}

/// The card validation exception. Thrown when the card data is invalid.
class CieloCardValidationException implements Exception {

  /// Field name that failed validation.
  final String field;

  /// Error code to identify the validation problem.
  final String code;

  /// User-friendly error message localized by core option's language.
  final String? message;

  CieloCardValidationException({
    required this.field,
    required this.code,
    this.message,
  });

  @override
  String toString() =>
      '[CieloCardValidationException] $field - $code - $message';
}
