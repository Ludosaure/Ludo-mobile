class GameCategory {
  final String id;
  final String name;

  GameCategory({required this.id, required this.name,});

  factory GameCategory.fromJson(Map<String, dynamic> json) {
    return GameCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}