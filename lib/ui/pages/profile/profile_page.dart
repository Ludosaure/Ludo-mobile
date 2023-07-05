import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/update_user/update_user_bloc.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:ludo_mobile/ui/components/circle-avatar.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/ui/pages/profile/update_password_alert.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/menu_items.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class ProfilePage extends StatefulWidget {
  final User connectedUser;

  const ProfilePage({
    required this.connectedUser,
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final SessionCubit _sessionCubit = locator<SessionCubit>();

  User get connectedUser => widget.connectedUser;
  late User displayedUser;

  @override
  void initState() {
    displayedUser = User.fromJson(connectedUser.toJson());
    super.initState();
  }

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
    return SingleChildScrollView(
      child: BlocConsumer<SessionCubit, SessionState>(
        listener: (context, state) {
          if (state is UserNotLogged) {
            context.go(Routes.login.path);
          }
        },
        builder: (context, state) {
          if (state is SessionInitial) {
            BlocProvider.of<SessionCubit>(context).checkSession();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is UserLoggedIn) {
            displayedUser = state.user;
            updatePhoneFormat();
            return _buildPageContent(context);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildPageContent(BuildContext context) {
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
          _buildNotifsInfosBody(context),
          const SizedBox(height: 20),
          if (!connectedUser.isAdmin())
            ElevatedButton(
              onPressed: () {
                context.push(Routes.userReservations.path);
              },
              child: const Text('my-reservations-title').tr(),
            ),
          const SizedBox(height: 10),
          _buildUpdatePasswordButton(context),
          const SizedBox(height: 10),
          _buildTermsAndConditions(context),
        ],
      ),
    );
  }

  Widget _buildTermsAndConditions(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(Routes.terms.path);
      },
      child: Text(
        'terms-of-use',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ).tr(),
    );
  }

  Widget _buildUpdatePasswordButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showUpdatePasswordAlert(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      child: const Text('update-password-title').tr(),
    );
  }

  Widget _buildUserInfosHeader(BuildContext context) {
    final logoutButtonSeparated =
        ResponsiveWrapper.of(context).isSmallerThan(MOBILE);

    final fullName = '${displayedUser.firstname} ${displayedUser.lastname}';
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
              userProfilePicture: displayedUser.profilePicturePath,
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
                            ? 17
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
            context.push(
              '${Routes.profile.path}/${Routes.updateProfile.path}',
              extra: connectedUser,
            );
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
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: Text(
            'personal-informations-title'.tr(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.alternate_email,
                    size: 20,
                  ),
                  SizedBox(width: size.width * 0.01),
                  Text(
                    displayedUser.email,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.phone,
                    size: 20,
                  ),
                  SizedBox(width: size.width * 0.01),
                  Text(
                    displayedUser.phone,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_box_outlined,
                    size: 20,
                  ),
                  SizedBox(width: size.width * 0.01),
                  Text(
                    (displayedUser.pseudo != null && displayedUser.pseudo != "")
                        ? displayedUser.pseudo!
                        : 'pseudo-to-set-field'.tr(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w100),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotifsInfosBody(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.notifications),
          title: Text(
            'notifications-parameters-title'.tr(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.notifications_none,
                      color: Colors.black,
                      size: 20,
                    ),
                    SizedBox(width: size.width * 0.01),
                    Text(
                      'activate-mail-notifications-label'.tr(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                trailing: displayedUser.hasEnabledMailNotifications
                    ? const Icon(Icons.check)
                    : const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _showUpdatePasswordAlert(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: locator<UpdateUserBloc>(),
            ),
          ],
          child: UpdatePasswordAlert(user: displayedUser),
        );
      },
    );
  }

  void _logout(BuildContext context) {
    _sessionCubit.logout();
    scheduleMicrotask(() {
      context.go(Routes.landing.path);
    });
  }

  void updatePhoneFormat() {
    if (displayedUser.phone.startsWith('+33')) {
      displayedUser.phone = displayedUser.phone.replaceFirst('+33', '0');
    }
  }
}
