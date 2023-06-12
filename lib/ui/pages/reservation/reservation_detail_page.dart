import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class ReservationDetailsPage extends StatelessWidget {
  const ReservationDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.5,
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            context.go(Routes.homeAdmin.path);
          },
        ),
      ),
      body: const Center(
        child: Text(
          "Reservation details page",
        ),
      ),
    );
  }
}
