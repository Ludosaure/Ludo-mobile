class UpdateUserRequest {
  final String userId;
  final String? password;
  final String? confirmPassword;
  final String? phoneNumber;
  final String? pseudo;
  final bool? hasEnabledMailNotifications;
  final String? profilePictureId;

  UpdateUserRequest({
    required this.userId,
    this.password,
    this.confirmPassword,
    this.phoneNumber,
    this.pseudo,
    this.hasEnabledMailNotifications,
    this.profilePictureId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'password': password,
      'confirmPassword': confirmPassword,
      'phoneNumber': phoneNumber,
      'pseudo': pseudo,
      'hasEnabledMailNotifications': hasEnabledMailNotifications,
      'profilePictureId': profilePictureId,
    };
  }
}