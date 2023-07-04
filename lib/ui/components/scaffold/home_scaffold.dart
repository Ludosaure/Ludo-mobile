import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/cart/cart_cubit.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:ludo_mobile/ui/components/menu/client_side_menu.dart';
import 'package:ludo_mobile/ui/components/menu/no_account_side_menu.dart';
import 'package:ludo_mobile/ui/components/nav_bar/app_bar/custom_app_bar.dart';
import 'package:ludo_mobile/ui/components/nav_bar/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:ludo_mobile/ui/components/nav_bar/bottom_nav_bar/no_account_bottom_nav_bar.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomeScaffold extends StatefulWidget {
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
  State<HomeScaffold> createState() => _HomeScaffoldState();
}

class _HomeScaffoldState extends State<HomeScaffold> {
  final CartCubit _cartCubit = locator<CartCubit>();
  User? get _user => widget.user;
  Widget get _body => widget.body;

  @override
  void initState() {
    _cartCubit.getCartContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      appBar: CustomAppBar(
        user: _user,
      ).build(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  Widget _buildBody(BuildContext context) {
    if (ResponsiveWrapper.of(context).isSmallerThan(TABLET)) {
      return _body;
    }

    return ResponsiveRowColumn(
      layout: ResponsiveRowColumnType.ROW,
      children: [
        ResponsiveRowColumnItem(
          child: Flexible(
            flex: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) ? 2 : 1,
            child: _user != null
                ? const ClientSideMenu()
                : const NoAccountSideMenu(),
          ),
        ),
        ResponsiveRowColumnItem(
          child: Flexible(
            flex: 5,
            child: _body,
          ),
        ),
      ],
    );
  }

  Widget? _buildBottomNavigationBar(BuildContext context) {
    final bool isTabletOrShorter =
        ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    if (_user != null) {
      return isTabletOrShorter
          ? BlocProvider.value(
              value: _cartCubit,
              child: CustomBottomNavigationBar(index: widget.navBarIndex, user: _user!),
            )
          : null;
    } else {
      return isTabletOrShorter ? const NoAccountBottomNavigationBar() : null;
    }
  }
}
