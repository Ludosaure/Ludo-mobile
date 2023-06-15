class Invoice {
  String id;
  int invoiceNumber;
  DateTime createdAt;
  double amount;
  int invoiceNbWeeks;
  String firstname;
  String lastname;
  String email;
  String phone;
  int reservationNumber;
  DateTime reservationStartDate;
  DateTime reservationEndDate;
  int reduction;
  int reservationNbWeeks;
  double reservationTotalAmount;

  Invoice({
    required this.id,
    required this.invoiceNumber,
    required this.createdAt,
    required this.amount,
    required this.invoiceNbWeeks,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.phone,
    required this.reservationNumber,
    required this.reservationStartDate,
    required this.reservationEndDate,
    required this.reduction,
    required this.reservationNbWeeks,
    required this.reservationTotalAmount,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'],
      invoiceNumber: json['invoiceNumber'],
      createdAt: DateTime.parse(json['createdAt']),
      amount: double.parse(json['amount']),
      invoiceNbWeeks: json['invoiceNbWeeks'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      phone: json['phone'],
      reservationNumber: json['reservationNumber'],
      reservationStartDate: DateTime.parse(json['reservationStartDate']),
      reservationEndDate: DateTime.parse(json['reservationEndDate']),
      reduction: json['reduction'],
      reservationNbWeeks: json['reservationNbWeeks'],
      reservationTotalAmount: double.parse(json['reservationTotalAmount']),
    );
  }
}