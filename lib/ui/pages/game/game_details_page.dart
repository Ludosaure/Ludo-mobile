import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/ui/components/custom_back_button.dart';

//WIP - Not finished yet
class GameDetailsPage extends StatelessWidget {
  final Game game;

  const GameDetailsPage({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomBackButton(),
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.20,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.down,
        children:[
          Image(
            image: NetworkImage(game.imageUrl),
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                game.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.favorite,
                color: Theme.of(context).colorScheme.secondary
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                game.description,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          )
        ],

      ),
    );
  }
}
