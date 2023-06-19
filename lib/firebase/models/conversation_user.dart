class ConversationUser {
  final String conversationId;
  final bool isSeen;

  ConversationUser({
    required this.conversationId,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'isSeen': isSeen,
    };
  }

  factory ConversationUser.fromMap(Map<String, dynamic> map) {
    return ConversationUser(
      conversationId: map['conversationId'],
      isSeen: map['isSeen'],
    );
  }
}