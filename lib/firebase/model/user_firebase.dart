import 'package:ludo_mobile/firebase/model/user_conversation.dart';

class UserFirebase {
  final List<UserConversation> conversations;
  final String email;
  final String firstname;
  final String name;
  final bool isAdmin;
  final String profilePicture;
  final String uid;

  UserFirebase({
    required this.conversations,
    required this.email,
    required this.firstname,
    required this.name,
    required this.isAdmin,
    required this.profilePicture,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return {
      'conversations':
          conversations.map((conversation) => conversation.toMap()).toList(),
      'email': email,
      'firstname': firstname,
      'name': name,
      'isAdmin': isAdmin,
      'profilePicture': profilePicture,
      'uid': uid,
    };
  }

  factory UserFirebase.fromMap(Map<String, dynamic> map) {
    List<UserConversation> conversations = [];
    if (map['conversations'] != null) {
      for(var conversation in map['conversations']) {
        conversations.add(UserConversation.fromMap(conversation));
      }
    }

    return UserFirebase(
      conversations: conversations,
      email: map['email'],
      firstname: map['firstname'],
      name: map['name'],
      isAdmin: map['isAdmin'],
      profilePicture: map['profilePicture'],
      uid: map['uid'],
    );
  }
}
