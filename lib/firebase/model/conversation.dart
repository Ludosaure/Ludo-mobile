import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ludo_mobile/firebase/model/message.dart';

class Conversation {
  final String conversationId;
  final List<String> members;
  final List<Message> messages;
  final String recentMessage;
  final String recentMessageSender;
  final DateTime recentMessageTime;
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
    List<String> members = [];
    if (map['members'] != null) {
      for (var member in map['members']) {
        members.add(member);
      }
    }

    List<Message> messages = [];
    if (map['messages'] != null) {
      for (var message in map['messages']) {
        messages.add(Message.fromMap(message));
      }
    }

    return Conversation(
      conversationId: map['conversationId'],
      members: members,
      messages: messages.reversed.toList(),
      recentMessage: map['recentMessage'],
      recentMessageSender: map['recentMessageSender'],
      recentMessageTime: (map['recentMessageTime'] as Timestamp).toDate(),
      targetUserId: map['targetUserId'],
    );
  }
}
