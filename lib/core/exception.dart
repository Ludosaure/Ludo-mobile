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