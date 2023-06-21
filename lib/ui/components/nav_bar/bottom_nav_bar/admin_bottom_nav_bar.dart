import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/user.dart' as db_user;
import 'package:ludo_mobile/firebase/service/firebase_database_service.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/menu_items.dart';
import 'package:badges/badges.dart';

class AdminBottomNavBar extends StatefulWidget {
  final db_user.User user;
  final int index;

  const AdminBottomNavBar({
    Key? key,
    required this.index,
    required this.user,
  }) : super(key: key);

  @override
  State<AdminBottomNavBar> createState() => _AdminBottomNavBarState();
}

class _AdminBottomNavBarState extends State<AdminBottomNavBar> {
  bool _hasUnseenConversations = false;

  @override
  void initState() {
    super.initState();
    _initHasUnseenConversations();
  }

  _initHasUnseenConversations() {
    final unreadConversationsStream =
        FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .hasUnseenConversationsStream();
    unreadConversationsStream.listen((hasUnreadConversations) {
      _hasUnseenConversations = hasUnreadConversations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.index,
      unselectedItemColor: Colors.grey[800],
      selectedItemColor: Theme.of(context).colorScheme.primary,
      items: [
        BottomNavigationBarItem(
          icon: Badge(
            badgeContent: const Text(
              '',
              style: TextStyle(color: Colors.white),
            ),
            showBadge: _hasUnseenConversations,
            child: Icon(AdminMenuItems.Messages.icon),
          ),
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
          context.go(Routes.inbox.path);
        } else if (index == AdminMenuItems.AddGame.index) {
          context.go(Routes.addGame.path);
        } else if (index == AdminMenuItems.Home.index) {
          context.go(Routes.homeAdmin.path);
        } else if (index == AdminMenuItems.Dashboard.index) {
          context.go(Routes.adminDashboard.path);
        } else if (index == AdminMenuItems.Profile.index) {
          context.go(Routes.profile.path);
        }
      },
    );
  }
}
