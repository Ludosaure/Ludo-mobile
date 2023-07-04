import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:responsive_framework/responsive_framework.dart';

class GameTile extends StatelessWidget {
  final Game game;
  final bool adminView;

  const GameTile({
    Key? key,
    required this.game,
    required this.adminView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _tileCard(context),
      ),
    );
  }

  Widget _tileCard(BuildContext context) {
    Widget leading = const FaIcon(
      FontAwesomeIcons.diceD20,
      color: Colors.grey,
    );

    if (game.imageUrl != null) {
      leading = Image.network(game.imageUrl!);
    }

    return ListTile(
      leading: leading,
      title: Text(game.name),
      subtitle: Text(game.categories.first.name),
      trailing: _buildTrailing(context),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    if (adminView) {
      return SizedBox(
        width: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                context.push(
                  '${Routes.game.path}/${game.id}/${Routes.gameUnavailabilities.path}',
                  extra: game,
                );
              },
              child: const Icon(
                Icons.edit_calendar_outlined,
                color: Colors.grey,
              ),
            ),
            GestureDetector(
              onTap: () {
                context.push(
                  '${Routes.game.path}/${game.id}/${Routes.updateGame.path}',
                  extra: game,
                );
              },
              child: const Icon(
                Icons.edit,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) ? 60 : null,
        child: Column(
          children: [
            Text(
              'amount',
              style: Theme.of(context).textTheme.titleMedium,
            ).tr(
              namedArgs: {
                'amount': game.weeklyAmount.toString(),
              },
            ),
            const Text(
              "weekly-amount-label",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ).tr(),
          ],
        ),
      );
    }
  }
}
