part of 'create_game_bloc.dart';

@immutable
abstract class CreateGameState {}

class CreateGameInitial extends CreateGameState {
  final String? id;
  final String name;
  final String? description;
  final double weeklyAmount;
  final String categoryId;
  final int minAge;
  final int averageDuration;
  final int minPlayers;
  final int maxPlayers;
  final dynamic image;
  final FormStatus status;


  CreateGameInitial({
    this.id,
    this.name = '',
    this.description = '',
    this.weeklyAmount = 0,
    this.categoryId = '',
    this.minAge = 0,
    this.averageDuration = 0,
    this.minPlayers = 0,
    this.maxPlayers = 0,
    this.image,
    this.status = const FormNotSent(),
  });

  CreateGameInitial copyWith({
    String? id,
    String? name,
    String? description,
    double? weeklyAmount,
    String? categoryId,
    int? minAge,
    int? averageDuration,
    int? minPlayers,
    int? maxPlayers,
    dynamic image,
    FormStatus? status = const FormNotSent(),
  }) {
    return CreateGameInitial(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      weeklyAmount: weeklyAmount ?? this.weeklyAmount,
      categoryId: categoryId ?? this.categoryId,
      minAge: minAge ?? this.minAge,
      averageDuration: averageDuration ?? this.averageDuration,
      minPlayers: minPlayers ?? this.minPlayers,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      image: image ?? this.image,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'CreateGameInitial('
        'id: $id, '
        'name: $name, '
        'description: $description, '
        'weeklyAmount: $weeklyAmount, '
        'categoryId: $categoryId, '
        'minAge: $minAge, '
        'averageDuration: $averageDuration, '
        'minPlayers: $minPlayers, '
        'maxPlayers: $maxPlayers, '
        'image: $image, '
        'status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreateGameInitial &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.weeklyAmount == weeklyAmount &&
      other.categoryId == categoryId &&
      other.minAge == minAge &&
      other.averageDuration == averageDuration &&
      other.minPlayers == minPlayers &&
      other.maxPlayers == maxPlayers &&
      other.image == image &&
      other.status == status;
  }

  @override
  int get hashCode {
    return
      id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      weeklyAmount.hashCode ^
      categoryId.hashCode ^
      minAge.hashCode ^
      averageDuration.hashCode ^
      minPlayers.hashCode ^
      maxPlayers.hashCode ^
      image.hashCode ^
      status.hashCode;
  }
}

class UserMustLog extends CreateGameInitial {}
