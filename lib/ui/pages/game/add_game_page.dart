import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class AddGamePage extends StatelessWidget {
  final User user;

  const AddGamePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      body: const Center(child: Text('Add Game Page')),
      navBarIndex: AdminMenuItems.AddGame.index,
      onSortPressed: null,
      onSearch: null,
      user: user,
    );
  }
}
