class Review {
  final String id;
  final String? title;
  final String? comment;
  final int rating;
  final String authorId;
  final String gameId;
  final DateTime createdAt;

  Review({
    required this.id,
    this.title,
    this.comment,
    required this.rating,
    required this.authorId,
    required this.gameId,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      title: json['title'],
      comment: json['comment'],
      rating: json['rating'],
      authorId: json['authorId'],
      gameId: json['gameId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'comment': comment,
      'rating': rating,
      'authorId': authorId,
      'gameId': gameId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

}