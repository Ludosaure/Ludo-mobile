class Conversation {
  UserConversation otherUser;
  LastMessage lastMessage;

  Conversation({
    required this.otherUser,
    required this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      otherUser: UserConversation.fromJson(json["otherUser"]),
      lastMessage: LastMessage.fromJson(json["lastMessage"]),
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

class LastMessage {
  String id;
  String content;
  DateTime sendDate;
  bool isRead;

  LastMessage({
    required this.id,
    required this.content,
    required this.sendDate,
    required this.isRead,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        id: json["id"],
        content: json["content"],
        sendDate: DateTime.parse(json["sendDate"]),
        isRead: json["isRead"],
      );
}
