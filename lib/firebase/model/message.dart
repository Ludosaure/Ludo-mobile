class Message {
  final String message;
  final String sender;
  final String time;

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
      time: map['time'],
    );
  }
}