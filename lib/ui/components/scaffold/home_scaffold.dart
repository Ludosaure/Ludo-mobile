import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/ui/components/nav_bar/app_bar/custom_app_bar.dart';
import 'package:ludo_mobile/ui/components/nav_bar/bottom_nav_bar/no_account_bottom_nav_bar.dart';

import '../nav_bar/bottom_nav_bar/bottom_nav_bar.dart';

class HomeScaffold extends StatelessWidget {
  final User? user;
  final Widget body;
  final int navBarIndex;
  final Widget? floatingActionButton;

  const HomeScaffold({
    Key? key,
    required this.body,
    required this.navBarIndex,
    this.user,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      appBar: const CustomAppBar().build(context),
      bottomNavigationBar: user != null
          ? CustomBottomNavigationBar(index: navBarIndex, user: user!)
          : const NoAccountBottomNavigationBar(),
      floatingActionButton: floatingActionButton,
    );
  }
}
