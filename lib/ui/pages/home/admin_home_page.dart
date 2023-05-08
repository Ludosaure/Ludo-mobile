import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/ui/pages/reservation/admin_reservation_list.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  //TODO avoir une liste pour les réservations en retard etc
  late List<Reservation> reservations = [
    Reservation(
      id: "1",
      reservationNumber: 1,
      gameName: "Monopoly",
      amount: 10.5,
      canceled: false,
      canceledAt: null,
      createdAt: DateTime.now(),
      createdBy: User(
        id: "1",
        firstname: "John",
        lastname: "Doe",
        email: "john.doe@gmail.com",
        phone: "0606060606",
        role: "ADMIN",
        hasVerifiedAccount: true,
        isAccountClosed: false,
        profilePicturePath: "assets/images/profile_picture.png",
        pseudo: "johndoe",
      ),
      // 3 months from now
      startDate: DateTime.now().add(const Duration(days: 90)),
      endDate: DateTime.now().add(const Duration(days: 97)),
      paid: false,
      returned: false,
      returnedAt: null,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: AdminReservationList(),
      ), navBarIndex: AdminMenuItems.Home.index,
    );
  }
}


