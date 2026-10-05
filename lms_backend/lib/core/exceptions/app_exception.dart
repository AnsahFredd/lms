abstract class AppException implements Exception {
  final String message;
  final int? code;
  final String? details;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.details,
    this.stackTrace,
  });

  @override
  String toString() => message;
}

class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error occurred',
    super.code = 500,
    super.details,
    super.stackTrace,
  });
}

class DatabaseException extends AppException {
  const DatabaseException({
    super.message = 'Database operation failed',
    super.code,
    super.details,
    super.stackTrace,
  });
}

class AuthException extends AppException {
  const AuthException({
    super.message = 'Authentication failed',
    super.code = 401,
    super.details,
    super.stackTrace,
  });
}

class AuthorizationException extends AppException {
  const AuthorizationException({
    super.message = 'You are not authorized to perform this action',
    super.code = 403,
    super.details,
    super.stackTrace,
  });
}

class ValidationException extends AppException {
  const ValidationException({
    super.message = 'Invalid request data',
    super.code = 400,
    super.details,
    super.stackTrace,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Requested resource was not found',
    super.code = 404,
    super.details,
    super.stackTrace,
  });
}

class ConflictException extends AppException {
  const ConflictException({
    super.message = 'The requested operation conflicts with existing data',
    super.code = 409,
    super.details,
    super.stackTrace,
  });
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Network connection failed',
    super.code,
    super.details,
    super.stackTrace,
  });
}

class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache operation failed',
    super.code,
    super.details,
    super.stackTrace,
  });
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'The operation timed out',
    super.code,
    super.details,
    super.stackTrace,
  });
}

class AIServiceException extends AppException {
  const AIServiceException({
    super.message = 'AI service is currently unavailable',
    super.code,
    super.details,
    super.stackTrace,
  });
}