part of 'list_all_reservations_cubit.dart';

@immutable
abstract class ListAllReservationsState {
  final SortedReservations reservations;
  const ListAllReservationsState({
    this.reservations = const SortedReservations(
      all: [],
      overdue: [],
      current: [],
      returned: [],
    )
  });
}

class ListAllReservationsInitial extends ListAllReservationsState {
  const ListAllReservationsInitial() : super();
}

class ListAllReservationsLoading extends ListAllReservationsState {
  const ListAllReservationsLoading() : super();
}

class ListReservationsSuccess extends ListAllReservationsState {
  const ListReservationsSuccess({required SortedReservations reservations})
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
