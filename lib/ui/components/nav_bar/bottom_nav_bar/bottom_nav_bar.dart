import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/ui/components/search_bar.dart';
import 'package:ludo_mobile/utils/menu_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomNavigationBar extends StatefulWidget {

  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = MenuItems.Home.index;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      unselectedItemColor: Colors.grey[800],
      selectedItemColor: Theme.of(context).colorScheme.primary,
      items: [
        BottomNavigationBarItem(
          icon: Icon(MenuItems.Messages.icon),
          label: MenuItems.Messages.label,
        ),
        BottomNavigationBarItem(
          icon: Icon(MenuItems.Search.icon),
          label: MenuItems.Search.label,
        ),
        BottomNavigationBarItem(
          icon: Icon(MenuItems.Home.icon),
          label: MenuItems.Home.label,
        ),
        BottomNavigationBarItem(
          icon: Icon(MenuItems.Favorites.icon),
          label: MenuItems.Favorites.label,
        ),
        BottomNavigationBarItem(
          icon: Icon(MenuItems.Profile.icon),
          label: MenuItems.Profile.label,
        ),
      ],
      onTap: (index) {
        if (index == MenuItems.Messages.index) {
          context.go('/inbox');
        }  else if (index == MenuItems.Search.index) {
          showDialog(
            context: context,
            builder: (context) {
              return const SearchBar();
            },
          );
          index = MenuItems.Home.index;
        } else if (index == MenuItems.Home.index) {
          context.go('/home');
        } else if (index == MenuItems.Profile.index) {
          SharedPreferences.getInstance().then((prefs) {
            prefs.remove('token');
          });
          context.go('/');
        } else if (index == MenuItems.Favorites.index) {
          context.go('/game-favorites');
        }

        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}
