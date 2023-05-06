import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoAccountBottomNavigationBar extends StatefulWidget {
  const NoAccountBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<NoAccountBottomNavigationBar> createState() => _NoAccountBottomNavigationBarState();
}

class _NoAccountBottomNavigationBarState extends State<NoAccountBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Colors.grey[800],
      unselectedItemColor: Colors.grey[800],
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.app_registration),
          label: 'Créer un compte',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.login),
          label: 'Se connecter',
        ),
      ],
      onTap: (index) {
        setState(() {
          if(index == 0) {
            SharedPreferences.getInstance().then((prefs) {
              prefs.remove('token');
              prefs.remove('user');
            });
            context.go('/register');
          } else {
            context.go('/login');
          }
        });
      },
    );
  }
}
