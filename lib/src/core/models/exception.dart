/// Exception thrown when the Cielo API returns an error.
class CieloAPIException implements Exception {

  final int code;
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
  final String field;
  final String code;
  final String? message;
  CieloException({
    required this.field,
    required this.code,
    this.message,
  });

  @override
  String toString() => '[CieloValidationException] $field - $code - $message';
}

class CieloCardValidationException implements Exception {
  final String field;
  final String code;
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
