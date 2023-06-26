import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PlanListPage extends StatelessWidget {
  const PlanListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text('list-plans-title').tr(),
      ),
      body: Center(
        child: const Text('list-plans-title').tr(),
      ),
    );
  }
}
