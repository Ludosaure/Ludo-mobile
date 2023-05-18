import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class GameFavoritesPage extends StatelessWidget {
  final User? user;

  const GameFavoritesPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      body: const Center(child: Text('Game Favorites Page')),
      navBarIndex: MenuItems.Favorites.index,
      user: user,
    );
  }
}
