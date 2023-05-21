part of 'list_all_reservations_cubit.dart';

@immutable
abstract class ListAllReservationsState {
  final List<Reservation> reservations;
  const ListAllReservationsState({
    this.reservations = const [],
  });
}

class ListAllReservationsInitial extends ListAllReservationsState {
  const ListAllReservationsInitial() : super();
}

class ListAllReservationsLoading extends ListAllReservationsState {
  const ListAllReservationsLoading() : super();
}

class ListReservationsSuccess extends ListAllReservationsState {
  const ListReservationsSuccess({required List<Reservation> reservations})
      : super(reservations: reservations);
}

class ListAllReservationsError extends ListAllReservationsState {
  final String message;
  const ListAllReservationsError({required this.message}) : super();
}

class UserMustLogError extends ListAllReservationsInitial {
  final String message;
  const UserMustLogError({required this.message}) : super();
}
