import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ludo_mobile/domain/models/game.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({
    Key? key,
    required this.game,
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
        padding: const EdgeInsets.only(bottom: 10.0),
        child: _gridTile(context),
      ),
    );
  }

  Widget _gridTile(BuildContext context) {
    Widget child = Container(
      width: MediaQuery.of(context).size.width * 0.20,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.88),
        borderRadius: BorderRadius.circular(10),
        shape: BoxShape.rectangle,
      ),
      child: const Center(
        child: FaIcon(
          FontAwesomeIcons.dice,
          color: Colors.white,
          size: 50,
        ),
      ),
    );

    if (game.imageUrl != null) {
      child = Image.network(game.imageUrl!);
    }

    return GridTile(
      footer: GridTileBar(
        backgroundColor: Colors.white,
        title: Text(
          game.name,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            height: 1.5,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              game.categories.join(', '),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'nb-players-label',
              style: Theme.of(context).textTheme.titleMedium,
            ).tr(
              namedArgs: {
                'minPlayers': game.minPlayers.toString(),
                'maxPlayers': game.maxPlayers.toString(),
              },
            ),
          ],
        ),
        trailing: Text(
          'weekly-amount',
          style: Theme.of(context).textTheme.titleMedium,
        ).tr(
          namedArgs: {
            'amount': game.weeklyAmount.toString(),
          },
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.75),
        child: child,
      ),
    );
  }
}
