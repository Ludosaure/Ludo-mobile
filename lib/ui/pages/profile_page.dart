import 'package:flutter/material.dart';
import 'package:ludo_mobile/ui/components/nav_bar/bottom_nav_bar/bottom_nav_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Profile Page')),
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
