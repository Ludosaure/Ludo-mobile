import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/get_user/get_user_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/update_user/update_user_bloc.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:ludo_mobile/ui/components/circle-avatar.dart';
import 'package:ludo_mobile/ui/components/custom_back_button.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/ui/pages/profile/update_password_alert.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/menu_items.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final SessionCubit _sessionCubit = locator<SessionCubit>();
  late User connectedUser;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetUserCubit, GetUserState>(builder: (context, state) {
      if (state is GetUserInitial) {
        BlocProvider.of<GetUserCubit>(context).getUser();
        return _chargingScaffold();
      }
      if (state is GetUserLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (state is GetUserSuccess) {
        connectedUser = state.user;
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
      return Container();
    }, listener: (context, state) {
      if (state is GetUserError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });
  }

  Widget _chargingScaffold() {
    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildPage(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
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
                child: Text('my-reservations-title'.tr()),
              ),
            _buildUpdatePasswordButton(context),
          ],
        ),
      ),
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
      child: Text('update-password-title'.tr()),
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
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.account_circle),
          title: Text(
            'personal-informations-title'.tr(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 20),
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
                  : 'pseudo-to-set-field'.tr(),
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

  Widget _buildNotifsInfosBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
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
        const SizedBox(height: 20),
        ListTile(
          leading: SizedBox(
            width: size.width * 0.6,
            child: Text(
              'activate-mail-notifications-label'.tr(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          title: connectedUser.hasEnabledMailNotifications
              ? const Icon(Icons.check)
              : const Icon(Icons.close),
        ),
        SizedBox(height: size.height * 0.01),
        ListTile(
          leading: SizedBox(
            width: size.width * 0.6,
            child: Text(
              'activate-app-notifications-label'.tr(),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
          title: connectedUser.hasEnabledPhoneNotifications
              ? const Icon(Icons.check)
              : const Icon(Icons.close),
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
          child: UpdatePasswordAlert(user: connectedUser),
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
}
