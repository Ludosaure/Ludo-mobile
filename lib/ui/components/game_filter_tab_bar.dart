import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class GameFilterTabBar extends StatelessWidget {
  const GameFilterTabBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: Theme.of(context).colorScheme.primary,
      indicatorColor: Theme.of(context).colorScheme.primary,
      tabs: [
        Tab(
          text: "all.masc".tr(),
        ),
        Tab(
          text: "availables".tr(),
        ),
      ],
    );
  }
}
