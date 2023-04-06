class BadRequestException implements Exception {
  final String message;
  const BadRequestException(this.message);
}

class LoginFailureException extends BadRequestException {
  const LoginFailureException(String message) : super(message);
}