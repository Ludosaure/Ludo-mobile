import 'package:ludo_mobile/utils/app_constants.dart';

class User {
  final String id;
  final String email;
  final String firstname;
  final String lastname;
  final String phone;
  final String? pseudo;
  final String? profilePicturePath;
  final String role;
  final bool hasVerifiedAccount;
  final bool isAccountClosed;


  User({
    required this.id,
    required this.email,
    required this.firstname,
    required this.lastname,
    required this.phone,
    this.pseudo,
    this.profilePicturePath,
    required this.role,
    required this.hasVerifiedAccount,
    required this.isAccountClosed,
  });

  bool isAdmin() {
    return role == AppConstants.ADMIN_ROLE;
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        phone: json["phone"],
        pseudo: json["pseudo"] ?? "",
        profilePicturePath: json["profilePicture"] != null ? json["profilePicture"]["url"] : "",
        role: json["role"],
        hasVerifiedAccount: json["isAccountVerified"],
        isAccountClosed: json["isAccountClosed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "phone": phone,
        "pseudo": pseudo,
        "profilePicturePath": profilePicturePath,
        "role": role,
        "isAccountVerified": hasVerifiedAccount,
        "isAccountClosed": isAccountClosed,
      };
}
