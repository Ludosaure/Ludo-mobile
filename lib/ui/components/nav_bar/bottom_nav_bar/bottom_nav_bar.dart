import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/ui/components/search_bar.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final User user;
  final int index;

  const CustomBottomNavigationBar({
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
          context.go(Routes.inbox.path, extra: user);
        } else if (index == MenuItems.Search.index) {
          showDialog(
            context: context,
            builder: (context) {
              return const SearchBar(
                showFilter: true,
                onSearch: null, //TODO
              );
            },
          );
        } else if (index == MenuItems.Home.index) {
          context.go(Routes.home.path, extra: user);
        } else if (index == MenuItems.Profile.index) {
          LocalStorageHelper.removeUserFromLocalStorage();
          context.go(Routes.landing.path);
        } else if (index == MenuItems.Favorites.index) {
          context.go(Routes.favorites.path, extra: user);
        }
      },
    );
  }
}
