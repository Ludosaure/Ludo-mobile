import 'package:flutter/material.dart';

class ReservationDetailsPage extends StatelessWidget {
  const ReservationDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Center(
        child: Text("Reservation details page"),
      ),
    );
  }
}
