import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/game.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: Image.network(
                game.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              game.name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 8),
                Icon(
                  Icons.favorite,
                  color: Colors.red[300],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
