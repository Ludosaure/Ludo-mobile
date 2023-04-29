part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {
  const RegisterEvent();
}

class RegisterSubmitEvent extends RegisterEvent {
  const RegisterSubmitEvent();
}

class FirstnameChangedEvent extends RegisterEvent {
  final String firstname;

  const FirstnameChangedEvent(this.firstname);
}

class LastnameChangedEvent extends RegisterEvent {
  final String lastname;

  const LastnameChangedEvent(this.lastname);
}

class EmailChangedEvent extends RegisterEvent {
  final String email;

  const EmailChangedEvent(this.email);
}

class PasswordChangedEvent extends RegisterEvent {
  final String password;

  const PasswordChangedEvent(this.password);
}

class PasswordConfirmationChangedEvent extends RegisterEvent {
  final String confirmPassword;

  const PasswordConfirmationChangedEvent(this.confirmPassword);
}

class PhoneChangedEvent extends RegisterEvent {
  final String phone;

  const PhoneChangedEvent(this.phone);
}
