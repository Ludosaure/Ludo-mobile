
class TermsAndConditions {
  DateTime createdAt;
  DateTime lastUpdatedAt;
  String content;

  TermsAndConditions({
    required this.createdAt,
    required this.lastUpdatedAt,
    required this.content,
  });

  factory TermsAndConditions.fromJson(Map<String, dynamic> json) {
    return TermsAndConditions(
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt']),
      content: json['content'],
    );
  }

}