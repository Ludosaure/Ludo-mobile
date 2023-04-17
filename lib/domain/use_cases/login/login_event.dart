part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {
  const LoginEvent();
}

class LoginSubmitEvent extends LoginEvent {
  const LoginSubmitEvent();
}

class LogoutEvent extends LoginEvent {
  const LogoutEvent();
}

class EmailChangedEvent extends LoginEvent {
  final String email;

  const EmailChangedEvent(this.email);
}

class PasswordChangedEvent extends LoginEvent {
  final String password;

  const PasswordChangedEvent(this.password);
}