import 'package:flutter/material.dart';
import 'package:ludo_mobile/ui/components/nav_bar/bottom_nav_bar/bottom_nav_bar.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Inbox Page')),
      appBar: AppBar(
        title: const Text('Inbox'),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar()
    );
  }
}
