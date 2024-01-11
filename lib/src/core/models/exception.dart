
/// Exception thrown when the Cielo API returns an error.
class CieloAPIException implements Exception {

  final int code;
  final String? message;

  CieloAPIException({
    required this.code,
    this.message = '',
  });

  String toString() => '[CieloAPIException] $code - $message';

}

/// Exception thrown for validation errors caught before making the request to Cielo API.
class CieloValidationException implements Exception {
    final String field;
    final String message;
    CieloValidationException({required this.field, required this.message});

    @override
    String toString() => '[CieloValidationException] $field - $message';
}