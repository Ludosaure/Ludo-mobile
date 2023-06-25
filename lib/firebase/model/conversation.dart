import 'package:ludo_mobile/firebase/model/message.dart';

class Conversation {
  final String conversationId;
  final List<String> members;
  final List<Message> messages;
  final String recentMessage;
  final String recentMessageSender;
  final String recentMessageTime;
  final String targetUserId;

  Conversation({
    required this.conversationId,
    required this.members,
    required this.messages,
    required this.recentMessage,
    required this.recentMessageSender,
    required this.recentMessageTime,
    required this.targetUserId,
  });

  Map<String, dynamic> toMap() {
    return {
      'conversationId': conversationId,
      'members': members,
      'messages': messages.map((message) => message.toMap()).toList(),
      'recentMessage': recentMessage,
      'recentMessageSender': recentMessageSender,
      'recentMessageTime': recentMessageTime,
      'targetUserId': targetUserId,
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      conversationId: map['conversationId'],
      members: map['members'] != null
          ? List<String>.from(map['members'])
          : [],
      messages: map['messages'] != null
          ? List<Message>.from(
              map['messages'].map((message) => Message.fromMap(message)))
          : [],
      recentMessage: map['recentMessage'],
      recentMessageSender: map['recentMessageSender'],
      recentMessageTime: map['recentMessageTime'],
      targetUserId: map['targetUserId'],
    );
  }
}
