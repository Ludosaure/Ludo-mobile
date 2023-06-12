part of 'create_reservation_bloc.dart';

@immutable
abstract class CreateReservationEvent {
  const CreateReservationEvent();
}

class CreateReservationSubmitEvent extends CreateReservationEvent {
  const CreateReservationSubmitEvent();
}

class CreateReservationRentPeriodChangedEvent extends CreateReservationEvent {
  final DateTimeRange rentPeriod;

  const CreateReservationRentPeriodChangedEvent(this.rentPeriod);
}

class CreateReservationCancelEvent extends CreateReservationEvent {
  const CreateReservationCancelEvent();
}