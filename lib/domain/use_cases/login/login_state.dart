part of 'login_bloc.dart';

class LoginState {
  final String email;
  final String password;
  final FormStatus status;

  LoginState({
    this.email = '',
    this.password = '',
    this.status = const FormNotSent(),
  });

  LoginState copyWith({
    String? email,
    String? password,
    FormStatus? status,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  //TODO utiliser equatable
  @override
  String toString() {
    return 'LoginState(email: $email, password: $password, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginState &&
        other.email == email &&
        other.password == password &&
        other.status == status;
  }

  @override
  int get hashCode {
    return email.hashCode ^ password.hashCode ^ status.hashCode;
  }
}
