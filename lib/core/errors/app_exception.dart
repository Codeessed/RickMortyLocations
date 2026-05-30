/// Sealed exception hierarchy for the Rick & Morty app.
///
/// All layers throw only [AppException] subclasses — never raw
/// [Exception] or [String]. Catching happens at the repository boundary;
/// the presentation layer consumes errors via [AsyncValue.error].
sealed class AppException implements Exception {
  const AppException();

  String get displayMessage;
}

/// Thrown when a network request fails (timeout, DNS, server error, etc.).
final class NetworkException extends AppException {
  final String message;
  final int? statusCode;

  const NetworkException({required this.message, this.statusCode});

  @override
  String get displayMessage =>
      statusCode != null ? '$message (HTTP $statusCode)' : message;

  @override
  String toString() => 'NetworkException: $displayMessage';
}

/// Thrown when the requested resource does not exist (404).
final class NotFoundException extends AppException {
  const NotFoundException();

  @override
  String get displayMessage => 'The requested resource was not found.';

  @override
  String toString() => 'NotFoundException';
}

/// Thrown when local cache read/write fails.
final class CacheException extends AppException {
  final String message;

  const CacheException({required this.message});

  @override
  String get displayMessage => 'Cache error: $message';

  @override
  String toString() => 'CacheException: $message';
}

/// Catch-all for unexpected errors.
final class UnknownException extends AppException {
  final Object cause;

  const UnknownException({required this.cause});

  @override
  String get displayMessage => 'Something went wrong. Please try again.';

  @override
  String toString() => 'UnknownException: $cause';
}
