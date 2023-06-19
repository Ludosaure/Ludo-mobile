import 'package:ludo_mobile/firebase/models/firebase_message.dart';

class FirebaseConversation {
  final String conversationId;
  final List<String> members;
  final List<FirebaseMessage> messages;
  final String recentMessage;
  final String recentMessageSender;
  final DateTime recentMessageTime;
  final String targetUserId;

  FirebaseConversation({
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
      'messages': messages.map((x) => x.toMap()).toList(),
      'recentMessage': recentMessage,
      'recentMessageSender': recentMessageSender,
      'recentMessageTime': recentMessageTime,
      'targetUserId': targetUserId,
    };
  }

  factory FirebaseConversation.fromMap(Map<String, dynamic> map) {
    return FirebaseConversation(
      conversationId: map['conversationId'],
      members: List<String>.from(map['members']),
      messages: List<FirebaseMessage>.from(map['messages']?.map((x) => FirebaseMessage.fromMap(x))),
      recentMessage: map['recentMessage'],
      recentMessageSender: map['recentMessageSender'],
      recentMessageTime: map['recentMessageTime'],
      targetUserId: map['targetUserId'],
    );
  }
}