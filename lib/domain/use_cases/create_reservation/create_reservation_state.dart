part of 'create_reservation_bloc.dart';

@immutable
abstract class CreateReservationState {}

// Add to cart -> création d'une reservation -> création d'un panier s'il n'existe pas
// Remove from cart -> suppression d'une reservation -> suppression d'un panier s'il est vide
class CreateReservationInitial extends CreateReservationState {
  final DateTimeRange? rentPeriod;
  final String gameId;

  CreateReservationInitial({
    this.rentPeriod,
    this.gameId = '',
  });

  CreateReservationInitial copyWith({
    DateTimeRange? rentPeriod,
    String? gameId,
  }) {
    return CreateReservationInitial(
      rentPeriod: rentPeriod ?? this.rentPeriod,
      gameId: gameId ?? this.gameId,
    );
  }

  @override
  String toString() {
    return 'CreateReservationInitial('
        'rentPeriod: $rentPeriod, '
        'gameId: $gameId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreateReservationInitial &&
      other.rentPeriod == rentPeriod &&
      other.gameId == gameId;
  }

  @override
  int get hashCode {
    return rentPeriod.hashCode ^
      gameId.hashCode;
  }

}
