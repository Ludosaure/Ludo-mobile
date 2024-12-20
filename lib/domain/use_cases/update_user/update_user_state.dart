part of 'update_user_bloc.dart';

@immutable
abstract class UpdateUserState {}

class UpdateUserInitial extends UpdateUserState {
  final String? userId;
  final String? password;
  final String? confirmPassword;
  final String? phoneNumber;
  final String? pseudo;
  final bool? hasEnabledMailNotifications;
  final dynamic image;
  final FormStatus status;

  UpdateUserInitial({
    this.userId,
    this.password,
    this.confirmPassword,
    this.phoneNumber,
    this.pseudo,
    this.hasEnabledMailNotifications,
    this.image,
    this.status = const FormNotSent(),
  });

  UpdateUserInitial copyWith({
    String? userId,
    String? password,
    String? confirmPassword,
    String? phoneNumber,
    String? pseudo,
    bool? hasEnabledMailNotifications,
    dynamic image,
    FormStatus? status = const FormNotSent(),
  }) {
    return UpdateUserInitial(
      userId: userId ?? this.userId,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pseudo: pseudo ?? this.pseudo,
      hasEnabledMailNotifications:
          hasEnabledMailNotifications ?? this.hasEnabledMailNotifications,
      image: image ?? this.image,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'UpdateUserInitial('
        'userId: $userId, '
        'password: $password, '
        'confirmPassword: $confirmPassword, '
        'phoneNumber: $phoneNumber, '
        'pseudo: $pseudo, '
        'hasEnabledMailNotifications: $hasEnabledMailNotifications, '
        'image: $image, '
        'status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdateUserInitial &&
        other.userId == userId &&
        other.password == password &&
        other.confirmPassword == confirmPassword &&
        other.phoneNumber == phoneNumber &&
        other.pseudo == pseudo &&
        other.hasEnabledMailNotifications == hasEnabledMailNotifications &&
        other.image == image &&
        other.status == status;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        password.hashCode ^
        confirmPassword.hashCode ^
        phoneNumber.hashCode ^
        pseudo.hashCode ^
        hasEnabledMailNotifications.hashCode ^
        image.hashCode ^
        status.hashCode;
  }
}

class UserMustLog extends UpdateUserInitial {}
