import 'package:ludo_mobile/firebase/models/conversation_user.dart';

class FirebaseUser {
  final String? uid;
  final String email;
  final String firstname;
  final String name;
  final bool isAdmin;
  final String? profilePicture;
  final List<ConversationUser> conversations;

  FirebaseUser({
    this.uid,
    required this.email,
    required this.firstname,
    required this.name,
    required this.isAdmin,
    required this.profilePicture,
    required this.conversations,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstname': firstname,
      'name': name,
      'isAdmin': isAdmin,
      'profilePicture': profilePicture,
      'conversations': conversations.map((x) => x.toMap()).toList(),
    };
  }

  factory FirebaseUser.fromMap(Map<String, dynamic> map) {
    return FirebaseUser(
      uid: map['uid'],
      email: map['email'],
      firstname: map['firstname'],
      name: map['name'],
      isAdmin: map['isAdmin'],
      profilePicture: map['profilePicture'],
      conversations: List<ConversationUser>.from(map['conversations']?.map((x) => ConversationUser.fromMap(x))),
    );
  }
}