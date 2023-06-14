class Plan {
  final String id;
  final String name;
  final int reduction;
  final int nbWeeks;

  Plan({
    required this.id,
    required this.name,
    required this.reduction,
    required this.nbWeeks,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      name: json['name'],
      reduction: json['reduction'],
      nbWeeks: json['nbWeeks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'reduction': reduction,
      'nbWeeks': nbWeeks,
    };
  }
}