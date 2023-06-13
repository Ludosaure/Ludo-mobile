import 'message.dart';

class Conversation {
  UserConversation otherUser;
  List<Message> messages;

  Conversation({
    required this.otherUser,
    required this.messages,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    final List<Message> messages = [];
    json["messages"] != null ? json["messages"].forEach((message) {
      messages.add(Message.fromJson(message));
    }) : [];

    return Conversation(
      otherUser: UserConversation.fromJson(json["otherUser"]),
      messages: messages,
    );
  }
}

class UserConversation {
  String id;
  String firstname;
  String lastname;
  final String? profilePicturePath;

  UserConversation({
    required this.id,
    required this.firstname,
    required this.lastname,
    this.profilePicturePath,
  });

  factory UserConversation.fromJson(Map<String, dynamic> json) =>
      UserConversation(
        id: json["id"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        profilePicturePath: json["profilePicture"] != null ? json["profilePicture"]["url"] : "",
      );
}
