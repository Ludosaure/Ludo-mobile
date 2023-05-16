import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/ui/components/nav_bar/app_bar/admin_app_bar.dart';
import 'package:ludo_mobile/ui/components/nav_bar/bottom_nav_bar/admin_bottom_nav_bar.dart';

class AdminScaffold extends StatelessWidget {
  final User user;
  final Widget body;
  final int navBarIndex;
  final void Function<T>(T selectedFilter)? onSortPressed;
  final void Function(String toSearch)? onSearch;

  const AdminScaffold({
    Key? key,
    required this.body,
    required this.navBarIndex,
    required this.onSortPressed,
    required this.onSearch,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      appBar: AdminAppBar(
        onSortPressed: onSortPressed,
        onSearch: onSearch,
      ).build(context),
      bottomNavigationBar: AdminBottomNavBar(index: navBarIndex, user: user),
    );
  }
}
