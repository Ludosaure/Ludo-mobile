import 'package:ludo_mobile/domain/models/reservation.dart';

class SortedReservations {
  final List<Reservation> all;
  final List<Reservation> late;
  final List<Reservation> current;
  final List<Reservation> returned;

  const SortedReservations({
    required this.all,
    required this.late,
    required this.current,
    required this.returned,
  });
}