import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/ui/components/search_bar.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/menu_items.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int index;
  const CustomBottomNavigationBar({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
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
          context.go(Routes.inbox.path);
        }  else if (index == MenuItems.Search.index) {
          showDialog(
            context: context,
            builder: (context) {
              return const SearchBar();
            },
          );
          index = MenuItems.Home.index;
        } else if (index == MenuItems.Home.index) {
          context.go(Routes.home.path);
        } else if (index == MenuItems.Profile.index) {
          SharedPreferences.getInstance().then((prefs) {
            prefs.remove('token');
          });
          context.go(Routes.landing.path);
        } else if (index == MenuItems.Favorites.index) {
          context.go(Routes.favorites.path);
        }
      },
    );
  }
}
