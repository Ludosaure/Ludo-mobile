class FirebaseMessage {
  final String message;
  final String sender;
  final DateTime time;
  // TODO vérifier que la date est au bon format

  FirebaseMessage({
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

  factory FirebaseMessage.fromMap(Map<String, dynamic> map) {
    return FirebaseMessage(
      message: map['message'],
      sender: map['sender'],
      time: map['time'],
    );
  }
}