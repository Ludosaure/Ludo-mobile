import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/ui/components/menu/client_side_menu.dart';
import 'package:ludo_mobile/ui/components/menu/no_account_side_menu.dart';
import 'package:ludo_mobile/ui/components/nav_bar/app_bar/custom_app_bar.dart';
import 'package:ludo_mobile/ui/components/nav_bar/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:ludo_mobile/ui/components/nav_bar/bottom_nav_bar/no_account_bottom_nav_bar.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class HomeScaffold extends StatelessWidget {
  final User? user;
  final Widget body;
  final int navBarIndex;
  final Widget? floatingActionButton;

  const HomeScaffold({
    Key? key,
    required this.body,
    required this.navBarIndex,
    this.user,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      appBar: CustomAppBar(
        user: user,
      ).build(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: floatingActionButton,
    );
  }

  Widget _buildBody(BuildContext context) {
    if (ResponsiveWrapper.of(context).isSmallerThan(TABLET)) {
      return body;
    }
    return ResponsiveRowColumn(
      layout: ResponsiveRowColumnType.ROW,
      children: [
        ResponsiveRowColumnItem(
          child: Flexible(
            flex: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) ? 2 : 1,
            child: user != null
                ? const ClientSideMenu()
                : const NoAccountSideMenu(),
          ),
        ),
        ResponsiveRowColumnItem(
          child: Flexible(
            flex: 5,
            child: body,
          ),
        ),
      ],
    );
  }

  Widget? _buildBottomNavigationBar(BuildContext context) {
    final bool isTabletOrShorter =
        ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    if (user != null) {
      return isTabletOrShorter
          ? CustomBottomNavigationBar(index: navBarIndex, user: user!)
          : null;
    } else {
      return isTabletOrShorter ? const NoAccountBottomNavigationBar() : null;
    }
  }
}
