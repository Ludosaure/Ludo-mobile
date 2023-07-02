class Plan {
  final String id;
  final String name;
  final int reduction;
  final int nbWeeks;
  bool isActive;

  Plan({
    required this.id,
    required this.name,
    required this.reduction,
    required this.nbWeeks,
    required this.isActive,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      name: json['name'],
      reduction: json['reduction'],
      nbWeeks: json['nbWeeks'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'reduction': reduction,
      'nbWeeks': nbWeeks,
      'isActive': isActive,
    };
  }
}