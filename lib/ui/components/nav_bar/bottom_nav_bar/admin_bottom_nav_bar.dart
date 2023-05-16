import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class AdminBottomNavBar extends StatelessWidget {
  final User user;
  final int index;

  const AdminBottomNavBar({
    Key? key,
    required this.index,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      unselectedItemColor: Colors.grey[800],
      selectedItemColor: Theme.of(context).colorScheme.primary,
      items: [
        BottomNavigationBarItem(
          icon: Icon(AdminMenuItems.Messages.icon),
          label: AdminMenuItems.Messages.label,
        ),
        BottomNavigationBarItem(
          icon: Icon(AdminMenuItems.AddGame.icon),
          label: AdminMenuItems.AddGame.label,
        ),
        BottomNavigationBarItem(
          icon: Icon(AdminMenuItems.Home.icon),
          label: AdminMenuItems.Home.label,
        ),
        BottomNavigationBarItem(
          icon: Icon(AdminMenuItems.Dashboard.icon),
          label: AdminMenuItems.Dashboard.label,
        ),
        BottomNavigationBarItem(
          icon: Icon(AdminMenuItems.Profile.icon),
          label: AdminMenuItems.Profile.label,
        ),
      ],
      onTap: (index) {
        if (index == AdminMenuItems.Messages.index) {
          context.go(Routes.inbox.path, extra: user);
        } else if (index == AdminMenuItems.AddGame.index) {
          context.go(Routes.addGame.path, extra: user);
        } else if (index == AdminMenuItems.Home.index) {
          context.go(Routes.homeAdmin.path, extra: user);
        } else if (index == AdminMenuItems.Dashboard.index) {
          context.go(Routes.adminDashboard.path, extra: user);
        } else if (index == AdminMenuItems.Profile.index) {
          LocalStorageHelper.removeUserFromLocalStorage();
          context.go(Routes.landing.path);
        }
      },
    );
  }
}
