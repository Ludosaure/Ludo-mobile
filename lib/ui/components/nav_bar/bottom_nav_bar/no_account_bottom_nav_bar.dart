import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';

class NoAccountBottomNavigationBar extends StatefulWidget {
  const NoAccountBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<NoAccountBottomNavigationBar> createState() => _NoAccountBottomNavigationBarState();
}

class _NoAccountBottomNavigationBarState extends State<NoAccountBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Colors.grey[800],
      unselectedItemColor: Colors.grey[800],
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.app_registration),
          label: 'create-account-label'.tr(),
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.login),
          label: 'login-label'.tr(),
        ),
      ],
      onTap: (index) {
        setState(() {
          if(index == 0) {
            LocalStorageHelper.removeUserFromLocalStorage();
            context.go(Routes.register.path);
          } else {
            context.go(Routes.login.path);
          }
        });
      },
    );
  }
}
