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
        padding: const EdgeInsets.all(8.0),
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
      ),
      child: const Center(
        child: FaIcon(
          FontAwesomeIcons.dice,
          color: Colors.white,
          size: 50,
        ),
      ),
    );

    if(game.imageUrl != null) {
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
                '${game.minPlayers} - ${game.maxPlayers} joueurs',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ]),
        trailing: Text(
          '${game.weeklyAmount} €',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      child: child,
    );
  }
}
