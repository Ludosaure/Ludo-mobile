class Message {
  final String id;
  final String content;
  final DateTime sendDate;
  final bool isRead;

  Message({
    required this.id,
    required this.content,
    required this.sendDate,
    required this.isRead,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      content: json["content"],
      sendDate: DateTime.parse(json['sendDate']),
      isRead: json['isRead'],
    );
  }
}
