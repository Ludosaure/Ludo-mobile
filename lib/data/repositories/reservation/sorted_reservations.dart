import 'package:ludo_mobile/domain/models/reservation.dart';

class SortedReservations {
  final List<Reservation> all;
  final List<Reservation> overdue;
  final List<Reservation> current;
  final List<Reservation> returned;

  const SortedReservations({
    required this.all,
    required this.overdue,
    required this.current,
    required this.returned,
  });
}