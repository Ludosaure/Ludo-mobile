import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/ui/components/nav_bar/app_bar/custom_admin_app_bar.dart';
import 'package:ludo_mobile/ui/components/nav_bar/bottom_nav_bar/admin_bottom_nav_bar.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1,
          ),
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            return Text("${reservations[index].gameName} ${reservations[index].amount}");
          },
        ),
      ),
      bottomNavigationBar: const AdminBottomNavBar(),
      appBar: const AdminAppBar().build(context),
    );
  }
}
