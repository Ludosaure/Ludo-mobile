import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/reservation_provider.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';

@injectable
class ReservationRepository {
  final ReservationProvider _reservationProvider;

  ReservationRepository(this._reservationProvider);

  Future<List<Reservation>> getReservations() async {
    return await _reservationProvider.getReservations();
  }
}