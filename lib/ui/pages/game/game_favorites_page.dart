import 'package:flutter/material.dart';
import 'package:ludo_mobile/ui/components/nav_bar/bottom_nav_bar/bottom_nav_bar.dart';

class GameFavoritesPage extends StatelessWidget {
  const GameFavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Game Favorites Page')),
      appBar: AppBar(
        title: const Text('Game Favorites'),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
