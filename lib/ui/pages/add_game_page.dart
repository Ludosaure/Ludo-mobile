import 'package:flutter/material.dart';
import 'package:ludo_mobile/ui/components/nav_bar/app_bar/admin_app_bar.dart';
import 'package:ludo_mobile/ui/components/nav_bar/bottom_nav_bar/admin_bottom_nav_bar.dart';

class AddGamePage extends StatelessWidget {
  const AddGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Add Game Page')),
      appBar: const AdminAppBar().build(context),
      bottomNavigationBar: const AdminBottomNavBar(),
    );
  }
}
