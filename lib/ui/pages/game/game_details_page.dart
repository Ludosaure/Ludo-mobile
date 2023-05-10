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
        mainAxisAlignment: MainAxisAlignment.start,
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
              Icon(
                Icons.favorite,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
          _buildGameDescription(context)
        ],
      ),
      bottomNavigationBar: _buildGameDetailsBottomBar(context),
    );
  }

  Widget _buildGameImage(BuildContext context) {
    if (game.imageUrl != null) {
      return Image(
        image: NetworkImage(game.imageUrl!),
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
      );
    }
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Icon(
        FontAwesomeIcons.diceD20,
        size: 100,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildGameDescription(BuildContext context) {
    if (game.description == null) {
      return const Spacer();
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Text(
          game.description!,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildGameDetailsBottomBar(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.23,
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
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(
                  Icons.elderly_woman,
                  color: Colors.white,
                ),
              ),
              const Text(
                "Age minimum",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${game.minAge} ans",
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
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(
                  Icons.timer_outlined,
                  color: Colors.white,
                ),
              ),
              const Text(
                "Durée d'une partie",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${game.averageDuration} min",
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
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.white,
                  )),
              const SizedBox(height: 8),
              const Text(
                "-", //TODO réservation
                style: TextStyle(
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
              const Text(
                "Prix à la semaine",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${game.weeklyAmount} €",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 22.0, horizontal: 10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 40),
                maximumSize: const Size(100, 40),
                padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                visualDensity: VisualDensity.compact,
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: const Text("Réserver"),
            ),
          ),
        ],
      ),
    );
  }
}
