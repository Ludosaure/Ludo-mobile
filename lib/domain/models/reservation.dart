import 'package:ludo_mobile/domain/models/user.dart';

class Reservation {
  String id;
  int reservationNumber;
  User createdBy;
  String gameName;
  double amount;
  DateTime startDate;
  DateTime endDate;
  DateTime createdAt;
  bool returned;
  DateTime? returnedAt;
  bool paid;
  bool canceled;
  DateTime? canceledAt;

  Reservation({
    required this.id,
    required this.reservationNumber,
    required this.createdBy,
    required this.gameName,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.returned,
    this.returnedAt,
    required this.paid,
    required this.canceled,
    this.canceledAt,
  });
}