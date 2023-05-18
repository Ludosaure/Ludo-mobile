import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class InboxPage extends StatelessWidget {
  final User user;

  const InboxPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _getScaffold();
  }

  Widget _getScaffold() {
    if (user.isAdmin()) {
      return AdminScaffold(
        body: const Center(
          child: Text('Inbox Page'),
        ),
        user: user,
        onSearch: null,
        onSortPressed: null,
        navBarIndex: MenuItems.Messages.index,
      );
    }

    return HomeScaffold(
      body: const Center(
        child: Text('Inbox Page'),
      ),
      user: user,
      navBarIndex: MenuItems.Messages.index,
    );
  }
}
