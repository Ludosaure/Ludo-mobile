part of 'update_game_bloc.dart';

@immutable
abstract class UpdateGameState {
}

class UpdateGameInitial extends UpdateGameState {
  final String id;
  final String? name;
  final String? description;
  final double? weeklyAmount;
  final String? categoryId;
  final int? minAge;
  final int? averageDuration;
  final int? minPlayers;
  final int? maxPlayers;
  final File? image;
  final FormStatus status;

  UpdateGameInitial({
    this.id = '',
    this.name,
    this.description,
    this.weeklyAmount,
    this.categoryId,
    this.minAge,
    this.averageDuration,
    this.minPlayers,
    this.maxPlayers,
    this.image,
    this.status = const FormNotSent(),
  });

  UpdateGameInitial copyWith({
    String? id,
    String? name,
    String? description,
    double? weeklyAmount,
    String? categoryId,
    int? minAge,
    int? averageDuration,
    int? minPlayers,
    int? maxPlayers,
    File? image,
    FormStatus? status = const FormNotSent(),
  }) {
    return UpdateGameInitial(
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
    return 'UpdateGameInitial('
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

    return other is UpdateGameInitial &&
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
    return id.hashCode ^
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

class UserMustLog extends UpdateGameInitial {}
