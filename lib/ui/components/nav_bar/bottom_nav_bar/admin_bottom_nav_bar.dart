import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/utils/menu_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminBottomNavBar extends StatefulWidget {
  const AdminBottomNavBar({Key? key}) : super(key: key);

  @override
  State<AdminBottomNavBar> createState() => _AdminBottomNavBarState();
}

class _AdminBottomNavBarState extends State<AdminBottomNavBar> {
  int _currentIndex = AdminMenuItems.Home.index;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
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
        if( index == AdminMenuItems.Messages.index ) {
          print('Messages');
          context.go('/messages');
        }
        else if(index == AdminMenuItems.AddGame.index ) {
          print('Add Game');
          context.go('/add-game');
        }
        else if(index == AdminMenuItems.Home.index ) {
          context.go('/home/admin');
        }
        else if(index == AdminMenuItems.Dashboard.index) {
          context.go('/dashboard');
        }
        else if(index == AdminMenuItems.Profile.index ) {
          SharedPreferences.getInstance().then((prefs) {
            print('remove token');
            prefs.remove('token');
            prefs.remove('user');
            context.go('/');
          });
        }

        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
