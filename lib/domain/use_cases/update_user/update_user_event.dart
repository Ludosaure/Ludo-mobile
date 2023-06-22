part of 'update_user_bloc.dart';

@immutable
abstract class UpdateUserEvent {
  const UpdateUserEvent();
}

class UpdateUserSubmitEvent extends UpdateUserEvent {
  const UpdateUserSubmitEvent();
}

class UserPasswordChangedEvent extends UpdateUserEvent {
  final String password;

  const UserPasswordChangedEvent(this.password);
}

class UserConfirmPasswordChangedEvent extends UpdateUserEvent {
  final String confirmPassword;

  const UserConfirmPasswordChangedEvent(this.confirmPassword);
}

class UserPhoneNumberChangedEvent extends UpdateUserEvent {
  final String phoneNumber;

  const UserPhoneNumberChangedEvent(this.phoneNumber);
}

class UserPseudoChangedEvent extends UpdateUserEvent {
  final String pseudo;

  const UserPseudoChangedEvent(this.pseudo);
}

class UserHasEnabledMailNotificationsChangedEvent extends UpdateUserEvent {
  final bool hasEnabledMailNotifications;

  const UserHasEnabledMailNotificationsChangedEvent(this.hasEnabledMailNotifications);
}

class UserHasEnabledPhoneNotificationsChangedEvent extends UpdateUserEvent {
  final bool hasEnabledPhoneNotifications;

  const UserHasEnabledPhoneNotificationsChangedEvent(this.hasEnabledPhoneNotifications);
}

class UserPictureChangedEvent extends UpdateUserEvent {
  final File picture;

  const UserPictureChangedEvent(this.picture);
}

class UserIdChangedEvent extends UpdateUserEvent {
  final String userId;

  const UserIdChangedEvent(this.userId);
}
