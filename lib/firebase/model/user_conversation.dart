class UserConversation {
  final String conversationId;
  bool isSeen;

  UserConversation({
    required this.conversationId,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'isSeen': isSeen,
    };
  }

  factory UserConversation.fromMap(Map<String, dynamic> map) {
    return UserConversation(
      conversationId: map['conversationId'],
      isSeen: map['isSeen'],
    );
  }
}