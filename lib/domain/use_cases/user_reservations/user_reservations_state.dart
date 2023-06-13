part of 'user_reservations_cubit.dart';

@immutable
abstract class UserReservationsState {
  final List<Reservation> reservations;
  const UserReservationsState({
    this.reservations = const [],
  });
}

class UserReservationsInitial extends UserReservationsState {
  const UserReservationsInitial() : super();
}

class UserReservationsLoading extends UserReservationsState {
  const UserReservationsLoading() : super();
}

class UserReservationsSuccess extends UserReservationsState {
  const UserReservationsSuccess({required List<Reservation> reservations})
      : super(reservations: reservations);
}

class UserReservationsError extends UserReservationsState {
  final String message;
  const UserReservationsError({required this.message}) : super();
}

class UserMustLogError extends UserReservationsInitial {
  final String message;
  const UserMustLogError({required this.message}) : super();
}
