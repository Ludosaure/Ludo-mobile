import 'package:flutter/material.dart';
import 'package:ludo_mobile/ui/components/scaffold/home_scaffold.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      body: const Center(
        child: Text('Inbox Page'),
      ),
      navBarIndex: MenuItems.Messages.index,
    );
  }
}
