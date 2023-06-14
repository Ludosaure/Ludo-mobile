enum ReservationStatus {
  RUNNING,
  LATE,
  CANCELED,
  RETURNED,
  PAID,
  PENDING_PAIEMENT
}

extension ReservationStatusExtension on ReservationStatus {
  String get label {
    switch (this) {
      case ReservationStatus.RUNNING:
        return 'En cours';
      case ReservationStatus.LATE:
        return 'En retard';
      case ReservationStatus.CANCELED:
        return 'Annulée';
      case ReservationStatus.RETURNED:
        return 'Rendue';
      case ReservationStatus.PAID:
        return 'Payée';
      case ReservationStatus.PENDING_PAIEMENT:
        return 'En attente de paiement';
    }
  }
}