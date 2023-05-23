import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      subtitle: Text(game.categories.join(', ')),
      trailing: Text(
        '${game.weeklyAmount} €',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
