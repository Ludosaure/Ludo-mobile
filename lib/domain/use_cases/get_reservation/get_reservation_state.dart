part of 'get_reservation_cubit.dart';

@immutable
abstract class GetReservationState {
  const GetReservationState();
}

class GetReservationInitial extends GetReservationState {}

class GetReservationLoading extends GetReservationState {}

class GetReservationSuccess extends GetReservationState {
  final Reservation reservation;

  const GetReservationSuccess({required this.reservation});
}

class GetReservationError extends GetReservationState {
  final String message;

  const GetReservationError({required this.message});
}

class UserNotLoggedIn extends GetReservationState {}
