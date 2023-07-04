import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/data/repositories/favorite/favorite_game.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/ui/components/favorite_button.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class FavoriteGamesList extends StatelessWidget {
  final List<FavoriteGame> favorites;

  const FavoriteGamesList({Key? key, required this.favorites})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext parentContext) {
    return ListView.builder(
      itemCount: favorites.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        FavoriteGame favorite = favorites[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            leading: favorite.picture != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Image(
                      image: NetworkImage(favorite.picture!),
                      fit: BoxFit.contain,
                      height: MediaQuery.of(context).size.height * 0.13,
                      width: MediaQuery.of(context).size.width * 0.13,
                    ),
                  )
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.diceD20,
                      color: Colors.grey,
                    ),
                  ),
            onTap: () {
              context.push('${Routes.game.path}/${favorite.gameId}');
            },
            title: SizedBox(
              height: 50,
              child: Center(
                child: Text(
                  favorite.name,
                ),
              ),
            ),
            trailing: FavoriteButton(
              game: Game.onlyWithId(favorite.gameId),
            ),
          ),
        );
      },
    );
  }
}
