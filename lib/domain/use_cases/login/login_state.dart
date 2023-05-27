part of 'login_bloc.dart';

class LoginState {
  final String email;
  final String password;
  final FormStatus status;
  final User? loggedUser;

  LoginState({
    this.email = '',
    this.password = '',
    this.status = const FormNotSent(),
    this.loggedUser,
  });

  LoginState copyWith({
    String? email,
    String? password,
    FormStatus? status = const FormNotSent(),
    User? loggedUser,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      loggedUser: loggedUser ?? this.loggedUser,
    );
  }

  @override
  String toString() {
    return 'LoginState(email: $email, password: $password, status: $status, loggedUser: $loggedUser)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoginState &&
        other.email == email &&
        other.password == password &&
        other.status == status &&
        other.loggedUser == loggedUser;
  }

  @override
  int get hashCode {
    return email.hashCode ^ password.hashCode ^ status.hashCode ^ loggedUser.hashCode;
  }
}
