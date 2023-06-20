import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:ludo_mobile/ui/components/circle-avatar.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/menu_items.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildUserInfosHeader(context),
          const SizedBox(height: 20),
          _buildUserInfosBody(context),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.push(Routes.userReservations.path);
            },
            child: Text('my-reservations-title'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfosHeader(BuildContext context) {
    final logoutButtonSeparated =
        ResponsiveWrapper.of(context).isSmallerThan(MOBILE);
    final fullName = '${connectedUser.firstname} ${connectedUser.lastname}';
    var maxCharName = 45;
    if (ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)) {
      maxCharName = 20;
    }
    final size = MediaQuery.of(context).size;
    var avatarHeight = size.height * 0.1;
    if (ResponsiveWrapper.of(context).isSmallerThan(MOBILE)) {
      avatarHeight = size.height * 0.05;
    } else if (ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)) {
      avatarHeight = size.height * 0.07;
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: logoutButtonSeparated
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.center,
          children: [
            CustomCircleAvatar(
              userProfilePicture: connectedUser.profilePicturePath,
              height: avatarHeight,
            ),
            SizedBox(width: size.width * 0.02),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName.length > maxCharName
                      ? "${fullName.substring(0, maxCharName)}..."
                      : fullName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize:
                        ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                            ? 18
                            : 26,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (logoutButtonSeparated) _buildLogoutButton(context),
              ],
            ),
            SizedBox(width: size.width * 0.01),
            if (!logoutButtonSeparated) _buildLogoutButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            // TODO modifier le profil
          },
          icon: const Icon(Icons.edit),
        ),
        IconButton(
          onPressed: () {
            _logout(context);
          },
          icon: const Icon(Icons.logout),
        ),
      ],
    );
  }

  Widget _buildUserInfosBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.email),
            SizedBox(width: size.width * 0.01),
            Text(
              connectedUser.email,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.phone),
            SizedBox(width: size.width * 0.01),
            Text(
              connectedUser.phone,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.account_box),
            SizedBox(width: size.width * 0.01),
            Text(
              (connectedUser.pseudo != null && connectedUser.pseudo != "")
                  ? connectedUser.pseudo!
                  : 'Pseudo à renseigner',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _logout(BuildContext context) {
    _sessionCubit.logout();
    scheduleMicrotask(() {
      context.go(Routes.landing.path);
    });
  }
}
