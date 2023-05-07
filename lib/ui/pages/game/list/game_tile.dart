import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/game.dart';

class GameTile extends StatelessWidget {
  final Game game;

  const GameTile({
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
        child: _tileCard(context),
      ),
    );
  }

  Widget _tileCard(BuildContext context) {
    return ListTile(
      leading: Image.network(game.imageUrl),
      title: Text(game.name),
      subtitle: Text(game.categories.join(', ')),
      trailing: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.favorite_border_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
