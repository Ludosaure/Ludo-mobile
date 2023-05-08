import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/ui/components/custom_back_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        children: [
          _buildGameImage(context),
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
              Icon(Icons.favorite,
                  color: Theme.of(context).colorScheme.secondary),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _buildGameDescription(context),
          )
        ],
      ),
      bottomNavigationBar: _buildGameDetailsBottomBar(context),
    );
  }

  Widget _buildGameImage(BuildContext context) {
    if(game.imageUrl != null) {
      return Image(
        image: NetworkImage(game.imageUrl!),
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
      );
    }
    return const Spacer();
  }

  Widget _buildGameDescription(BuildContext context) {
    if(game.description == null) {
      return const Spacer();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        game.description!,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildGameDetailsBottomBar(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.88),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.5,
        ),
        children: [
          Column(
            verticalDirection: VerticalDirection.down,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.groups,
                color: Colors.white,
              ),
              const Text(
                "Nombre de joueurs",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${game.minPlayers} - ${game.maxPlayers}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Column(
            verticalDirection: VerticalDirection.down,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.child,
                color: Colors.white,
              ),
              const Text(
                "Nombre de joueurs",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${game.minPlayers} - ${game.maxPlayers}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Icon(Icons.timer),
        ],
      ),
    );
  }
}
