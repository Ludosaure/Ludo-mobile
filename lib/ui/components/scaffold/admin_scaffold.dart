import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/ui/components/menu/admin_side_menu.dart';
import 'package:ludo_mobile/ui/components/nav_bar/app_bar/admin_app_bar.dart';
import 'package:ludo_mobile/ui/components/nav_bar/bottom_nav_bar/admin_bottom_nav_bar.dart';
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class AdminScaffold extends StatelessWidget {
  final User user;
  final Widget body;
  final int navBarIndex;
  final void Function<T>(T selectedFilter)? onSortPressed;
  final void Function(String toSearch)? onSearch;

  const AdminScaffold({
    Key? key,
    required this.body,
    required this.navBarIndex,
    required this.onSortPressed,
    required this.onSearch,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      appBar: const AdminAppBar().build(context),
      bottomNavigationBar: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
          ? AdminBottomNavBar(index: navBarIndex, user: user)
          : null,
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
            child: const AdminSideMenu(),
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
}
