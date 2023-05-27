import 'package:easy_localization/easy_localization.dart';
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
        return 'home-title'.tr();
      case MenuItems.Messages:
        return 'messages-title'.tr();
      case MenuItems.Search:
        return 'search-title'.tr();
      case MenuItems.Profile:
        return 'account-title'.tr();
      case MenuItems.Favorites:
        return 'favorites-title'.tr();
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
        return 'messages-title'.tr();
      case AdminMenuItems.AddGame:
        return 'add-game-title'.tr();
      case AdminMenuItems.Home:
        return 'reservation-title'.tr();
      case AdminMenuItems.Dashboard:
        return 'administration-title'.tr();
      case AdminMenuItems.Profile:
        return 'account-title'.tr();
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