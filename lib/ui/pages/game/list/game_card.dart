import 'package:flutter/material.dart';
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
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                '${game.minPlayers} - ${game.maxPlayers} joueurs',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ]),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.favorite_border),
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child: Image.network(game.imageUrl),
    );
  }
}
