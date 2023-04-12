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

class UserNotFoundException extends NotFoundException {
  const UserNotFoundException(String message) : super(message);
}

class BadCredentialsException extends BadRequestException {
  const BadCredentialsException(String message) : super(message);
}