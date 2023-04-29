part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String confirmPassword;
  final String phone;
  final FormStatus status;

  RegisterInitial({
    this.firstname = '',
    this.lastname = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.phone = '',
    this.status = const FormNotSent(),
  });

  RegisterInitial copyWith({
    String? firstname,
    String? lastname,
    String? email,
    String? password,
    String? confirmPassword,
    String? phone,
    FormStatus? status = const FormNotSent(),
  }) {
    return RegisterInitial(
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      phone: phone ?? this.phone,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'RegisterInitial('
        'firstname: $firstname, '
        'lastname: $lastname, '
        'email: $email, '
        'password: $password, '
        'confirmPassword: $confirmPassword, '
        'phone: $phone, '
        'status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegisterInitial &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.email == email &&
        other.password == password &&
        other.confirmPassword == confirmPassword &&
        other.phone == phone &&
        other.status == status;
  }

  @override
  int get hashCode {
    return firstname.hashCode ^
        lastname.hashCode ^
        email.hashCode ^
        password.hashCode ^
        confirmPassword.hashCode ^
        phone.hashCode ^
        status.hashCode;
  }
}
