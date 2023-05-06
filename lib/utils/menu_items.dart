import 'package:flutter/material.dart';

enum MenuItems {
  Messages,
  Search,
  Home,
  Favorites,
  Profile,
}

extension MenuItemsExtension on MenuItems {
  String get label {
    switch (this) {
      case MenuItems.Home:
        return 'Accueil';
      case MenuItems.Messages:
        return 'Mes messages';
      case MenuItems.Search:
        return 'Rechercher';
      case MenuItems.Profile:
        return 'Mon Compte';
      case MenuItems.Favorites:
        return 'Mes Favoris';
    }
  }

  IconData get icon {
    switch (this) {
      case MenuItems.Home:
        return Icons.home;
      case MenuItems.Messages:
        return Icons.message;
      case MenuItems.Search:
        return Icons.search;
      case MenuItems.Profile:
        return Icons.account_circle;
      case MenuItems.Favorites:
        return Icons.favorite;
    }
  }
}

enum AdminMenuItems {
  Messages,
  AddGame,
  Home,
  Dashboard,
  Profile,
}

extension AdminMenuItemsExtension on AdminMenuItems {
  String get label {
    switch (this) {
      case AdminMenuItems.Messages:
        return 'Mes messages';
      case AdminMenuItems.AddGame:
        return 'Ajouter un jeu';
      case AdminMenuItems.Home:
        return 'Réservations';
      case AdminMenuItems.Dashboard:
        return 'Administration';
      case AdminMenuItems.Profile:
        return 'Mon Compte';
    }
  }

  IconData get icon {
    switch (this) {
      case AdminMenuItems.Messages:
        return Icons.message;
      case AdminMenuItems.AddGame:
        return Icons.gamepad_rounded;
      case AdminMenuItems.Home:
        return Icons.home;
      case AdminMenuItems.Dashboard:
        return Icons.dashboard_outlined;
      case AdminMenuItems.Profile:
        return Icons.account_circle;
    }
  }
}