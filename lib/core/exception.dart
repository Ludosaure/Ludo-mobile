class BadRequestException implements Exception {
  final String message;
  const BadRequestException(this.message);

  @override
  String toString() => message;
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException(this.message);
  @override
  String toString() => message;
}

class ForbiddenException extends BadRequestException {
  const ForbiddenException(String message) : super(message);
}

class InternalServerException implements Exception {
  final String message;
  const InternalServerException(this.message);
  @override
  String toString() => message;
}

class LoginFailureException extends BadRequestException {
  const LoginFailureException(String message) : super(message);
}

class BadCredentialsException extends BadRequestException {
  const BadCredentialsException(String message) : super(message);
}

class EmailAlreadyUsedException extends BadRequestException {
  const EmailAlreadyUsedException(String message) : super(message);
}

class UnverifiedAccountException extends BadRequestException {
  const UnverifiedAccountException(String message) : super(message);
}

class ServiceUnavailableException extends InternalServerException {
  const ServiceUnavailableException(String message) : super(message);
}

class UserNotLoggedInException implements Exception {
  final String message;
  const UserNotLoggedInException(this.message);

  @override
  String toString() => message;
}

class NotAllowedException implements Exception {
  final String message;
  const NotAllowedException(this.message);

  @override
  String toString() => message;
}