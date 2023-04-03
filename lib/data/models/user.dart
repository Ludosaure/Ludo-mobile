class User {
  User({
    required this.id,
    required this.email,
    required this.password,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.pseudo,
    required this.profilePicturePath,
    required this.role,
    required this.hasVerifiedAccount,
    required this.isAccountClosed,
  });

  final String id;
  final String email;
  final String password;
  final String firstname;
  final String lastname;
  final String phone;
  final String pseudo;
  final String profilePicturePath;
  final String role;
  final bool hasVerifiedAccount;
  final bool isAccountClosed;

  //Est-ce qu'on en a bsn si j'ai un JsonUser ?
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        phone: json["phone"],
        pseudo: json["pseudo"] ?? "",
        profilePicturePath: json["profilePicturePath"] ?? "",
        role: json["role"],
        hasVerifiedAccount: json["isAccountVerified"],
        isAccountClosed: json["isAccountClosed"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
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
