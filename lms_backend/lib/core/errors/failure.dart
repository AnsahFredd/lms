class Failure {
  final String message;
  final int? code;
  final String? details;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.code,
    this.details,
    this.stackTrace,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred',
    super.code = 500,
    super.details,
    super.stackTrace,
  });
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({
    super.message = 'Database operation failed',
    super.code,
    super.details,
    super.stackTrace,
  });
}

class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Authentication failed',
    super.code = 401,
    super.details,
    super.stackTrace,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Cache operation failed',
    super.code,
    super.details,
    super.stackTrace,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Network connection failed',
    super.code,
    super.details,
    super.stackTrace,
  });
}

class AuthorizationFailure extends Failure {
  const AuthorizationFailure({
    super.message = 'You are not authorized to perform this action',
    super.code = 403,
    super.details,
    super.stackTrace,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Requested resource was not found',
    super.code = 404,
    super.details,
    super.stackTrace,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Invalid input provided',
    super.code = 400,
    super.details,
    super.stackTrace,
  });
}

class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'You do not have permission to perform this action',
    super.code = 403,
    super.details,
    super.stackTrace,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred',
    super.code,
    super.details,
    super.stackTrace,
  });
}

class AIServiceFailure extends Failure {
  const AIServiceFailure({
    super.message = 'AI service is currently unavailable',
    super.code,
    super.details,
    super.stackTrace,
  });
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'The operation timed out',
    super.code,
    super.details,
    super.stackTrace,
  });
}

class ConflictFailure extends Failure {
  const ConflictFailure({
    super.message = 'The requested operation conflicts with existing data',
    super.code = 409,
    super.details,
    super.stackTrace,
  });
}