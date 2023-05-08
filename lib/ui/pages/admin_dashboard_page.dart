import 'package:flutter/material.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      body: const Center(child: Text('Admin Dashboard Page')),
      navBarIndex: AdminMenuItems.Dashboard.index,
    );
  }
}
