import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/invoice.dart';
import 'package:ludo_mobile/domain/models/plan.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/reservation_status.dart';


class Reservation {
  String id;
  int reservationNumber;
  User createdBy;
  List<Game> games;
  double amount;
  DateTime startDate;
  DateTime endDate;
  int nbWeeks;
  DateTime createdAt;
  bool returned;
  DateTime? returnedAt;
  bool paid;
  bool canceled;
  DateTime? canceledAt;
  User? user;
  List<Invoice>? invoices;
  Plan? appliedPlan;

  Reservation({
    required this.id,
    required this.reservationNumber,
    required this.createdBy,
    required this.games,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.nbWeeks,
    required this.createdAt,
    required this.returned,
    this.returnedAt,
    required this.paid,
    required this.canceled,
    this.canceledAt,
    this.user,
    this.invoices,
    this.appliedPlan,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    List<Game> games = [];
    json["games"].forEach((game) {
      games.add(Game.fromJson(game));
    });

    List<Invoice> invoices = [];
    if(json["invoices"] != null) {
      json["invoices"].forEach((invoice) {
        invoices.add(Invoice.fromJson(invoice));
      });
    }

    return Reservation(
      id: json['id'],
      reservationNumber: json['reservationNumber'],
      createdBy: User.fromJson(json['user']),
      games: games,
      amount: double.parse(json['totalAmount']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      nbWeeks: json['nbWeeks'],
      createdAt: DateTime.parse(json['createdAt']),
      returned: json['isReturned'],
      returnedAt: json['returnedDate'] != null ? DateTime.parse(json['returnedDate']) : null,
      paid: json['isPaid'],
      canceled: json['isCancelled'],
      canceledAt: json['cancelledDate'] != null ? DateTime.parse(json['cancelledDate']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      invoices: invoices,
      appliedPlan: json['appliedPlan'] != null ? Plan.fromJson(json['appliedPlan']) : null,
    );
  }

  factory Reservation.fromJsonAndUser(Map<String, dynamic> json, User user) {
    return Reservation(
      id: json['id'],
      reservationNumber: json['reservationNumber'],
      createdBy: user,
      user: user,
      games: [],
      amount: double.parse(json['totalAmount']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      createdAt: DateTime.parse(json['createdAt']),
      returned: json['isReturned'],
      returnedAt: json['returnedDate'] != null ? DateTime.parse(json['returnedDate']) : null,
      paid: json['isPaid'],
      canceled: json['isCancelled'],
      canceledAt: json['cancelledDate'] != null ? DateTime.parse(json['cancelledDate']) : null,
      nbWeeks: json['nbWeeks'],
      appliedPlan: json['appliedPlan'] != null ? Plan.fromJson(json['appliedPlan']) : null,
    );
  }
}

extension ReservationExtension on Reservation {
  ReservationStatus get status {
    if (canceled) {
      return ReservationStatus.CANCELED;
    }
    if (returned) {
      return ReservationStatus.RETURNED;
    }
    DateTime now = DateTime.now();
    DateTime todayAtMidnight = DateTime(now.year, now.month, now.day);
    if (endDate.isBefore(todayAtMidnight) && !returned) {
      return ReservationStatus.LATE;
    }
    if (!paid) {
      return ReservationStatus.PENDING_PAIEMENT;
    }

    return ReservationStatus.RUNNING;
  }
}