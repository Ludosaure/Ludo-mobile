import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/reservation/reservation_provider.dart';
import 'package:ludo_mobile/data/repositories/reservation/new_reservation.dart';
import 'package:ludo_mobile/data/repositories/reservation/sorted_reservations.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:ludo_mobile/domain/reservation_status.dart';

@injectable
class ReservationRepository {
  final ReservationProvider _reservationProvider;

  ReservationRepository(this._reservationProvider);

  Future<SortedReservations> getReservations() async {
    List<Reservation> reservations = await _reservationProvider.getReservations();

    return _sortReservations(reservations);
  }

  Future<SortedReservations> getMyReservations() async {
    List<Reservation> reservations = await _reservationProvider.listUserReservations();

    return _sortReservations(reservations);
  }

  Future<Reservation> getReservation(String reservationId) async {
    return await _reservationProvider.getReservation(reservationId);
  }

  Future<NewReservation> createReservation(
      DateTimeRange bookingPeriod, List<Game> games) async {
    NewReservation reservation = NewReservation(
      rentPeriod: bookingPeriod,
      games: games,
    );

    final String reservationId =
        await _reservationProvider.createReservation(reservation);

    reservation.id = reservationId;

    return reservation;
  }

  Future<void> confirmReservationPayment(NewReservation reservation) async {
    await _reservationProvider.confirmReservationPayment(reservation);
  }

  Future<void> cancelReservation(String reservationId) async {
    await _reservationProvider.cancelReservation(reservationId);
  }

  Future<void> removeUnpaidReservation(String reservationId) async {
    await _reservationProvider.removeUnpaidReservation(reservationId);
  }

  Future<void> returnReservationGames(String reservationId) async {
    await _reservationProvider.returnReservationGames(reservationId);
  }

  SortedReservations _sortReservations(List<Reservation> reservations) {
    return SortedReservations(
      all: reservations,
      overdue: reservations
          .where((res) => res.status == ReservationStatus.LATE)
          .toList(),
      current: reservations
          .where((res) => res.status == ReservationStatus.RUNNING)
          .toList(),
      returned: reservations
          .where((res) => res.status == ReservationStatus.RETURNED)
          .toList(),
    );
  }
}
