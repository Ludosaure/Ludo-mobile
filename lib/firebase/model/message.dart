import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String sender;
  final DateTime time;

  Message({
    required this.message,
    required this.sender,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'sender': sender,
      'time': time,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      message: map['message'],
      sender: map['sender'],
      time: (map['time'] as Timestamp).toDate(),
    );
  }

}