import 'package:flutter/material.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      body: const Center(
        child: Text('Profile Page'),
      ),
      navBarIndex: MenuItems.Profile.index,
    );
  }
}
