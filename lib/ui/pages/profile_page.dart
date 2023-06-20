import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class ProfilePage extends StatelessWidget {
  final User connectedUser;

  late final SessionCubit _sessionCubit = locator<SessionCubit>();

  ProfilePage({
    Key? key,
    required this.connectedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (connectedUser.isAdmin()) {
      return AdminScaffold(
        body: _buildPage(context),
        user: connectedUser,
        onSearch: null,
        onSortPressed: null,
        navBarIndex: MenuItems.Profile.index,
      );
    }
    return HomeScaffold(
      body: _buildPage(context),
      navBarIndex: MenuItems.Profile.index,
      user: connectedUser,
    );
  }

  Widget _buildPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Column(
        verticalDirection: VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Center(
            child: Text(
              'Profile Page',
              style: TextStyle(fontSize: 30.0),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _logout(context);
            },
            child: const Text('Se déconnecter'),
          ),
          ElevatedButton(
            onPressed: () {
              context.push(Routes.userReservations.path);
            },
            child: const Text('Mes réservations'),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    _sessionCubit.logout();
    scheduleMicrotask(() {
      context.go(Routes.landing.path);
    });
  }
}
