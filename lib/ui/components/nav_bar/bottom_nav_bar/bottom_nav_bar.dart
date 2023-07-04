import 'dart:async';

import 'package:badges/badges.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/user.dart' as db_user;
import 'package:ludo_mobile/domain/use_cases/cart/cart_cubit.dart';
import 'package:ludo_mobile/firebase/service/firebase_database_service.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final db_user.User user;
  final int index;

  const CustomBottomNavigationBar({
    Key? key,
    required this.index,
    required this.user,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  bool _hasUnseenConversations = false;
  StreamSubscription<bool>? subscription;

  db_user.User get user => widget.user;

  @override
  void initState() {
    super.initState();
    _initHasUnseenConversations();
  }

  _initHasUnseenConversations() {
    final unreadConversationsStream =
        FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .hasUnseenConversationsStream();
    subscription = unreadConversationsStream.listen((hasUnreadConversations) {
      setState(() => _hasUnseenConversations = hasUnreadConversations);
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
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
            child: Icon(MenuItems.Messages.icon),
          ),
          label: MenuItems.Messages.label,
        ),
        BottomNavigationBarItem(
          icon: Icon(MenuItems.Favorites.icon),
          label: MenuItems.Favorites.label,
        ),
        BottomNavigationBarItem(
          icon: Icon(MenuItems.Home.icon),
          label: MenuItems.Home.label,
        ),
        BottomNavigationBarItem(
          icon: _buildCartIcon(context),
          label: MenuItems.Cart.label,
        ),
        BottomNavigationBarItem(
          icon: Icon(MenuItems.Profile.icon),
          label: MenuItems.Profile.label,
        ),
      ],
      onTap: (index) {
        if (index == MenuItems.Messages.index) {
          context.go(Routes.inbox.path);
        } else if (index == MenuItems.Favorites.index) {
          context.go(Routes.favorites.path);
        } else if (index == MenuItems.Home.index) {
          context.go(Routes.home.path);
        } else if (index == MenuItems.Cart.index) {
          context.go(Routes.cart.path);
        } else if (index == MenuItems.Profile.index) {
          context.go(Routes.profile.path);
        }
      },
    );
  }

  Widget _buildCartIcon(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (_, state) {
        if (state is LoadCartContentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        if (state is UserNotLogged) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "errors.user-must-log-for-access",
              ).tr(),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (_, state) {
        if(state is AddToCartInitial) {
          context.read<CartCubit>().getCartContent();
        }

        if (state is CartContentLoaded) {
          return Badge(
            badgeContent: Text(
              state.cartContent.length.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            showBadge: state.cartContent.isNotEmpty,
            child: Icon(MenuItems.Cart.icon),
          );
        }

        if (state is UserNotLogged) {
          context.go(Routes.login.path);
        }

        return Icon(MenuItems.Cart.icon);
      },
    );
  }
}
