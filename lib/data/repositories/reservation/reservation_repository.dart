import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/reservation/reservation_provider.dart';
import 'package:ludo_mobile/data/repositories/reservation/new_reservation.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';

@injectable
class ReservationRepository {
  final ReservationProvider _reservationProvider;

  ReservationRepository(this._reservationProvider);

  Future<List<Reservation>> getReservations() async {
    return await _reservationProvider.getReservations();
  }

  Future<List<Reservation>> getMyReservations() async {
    return await _reservationProvider.listUserReservations();
  }

  Future<Reservation> getReservation(String reservationId) async {
    return await _reservationProvider.getReservation(reservationId);
  }

  Future<NewReservation> createReservation(DateTimeRange bookingPeriod, List<Game> games) async {
    NewReservation reservation = NewReservation(
      rentPeriod: bookingPeriod,
      games: games,
    );

    final String reservationId = await _reservationProvider.createReservation(reservation);

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
}