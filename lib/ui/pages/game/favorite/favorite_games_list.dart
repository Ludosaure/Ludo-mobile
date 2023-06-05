import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/data/repositories/favorite/favorite_game.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class FavoriteGamesList extends StatelessWidget {
  final List<FavoriteGame> favorites;

  const FavoriteGamesList({Key? key, required this.favorites})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildList();
  }

  Widget _buildList() {
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
                ? Image(
                    image: NetworkImage(favorite.picture!),
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                  )
                : const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.diceD20,
                      color: Colors.grey,
                    ),
                  ),
            onTap: () {
              context.go('${Routes.game.path}/${favorite.gameId}');
            },
            title: Text(favorite.name),
            trailing: const Text("remove-from-favorites").tr(),
          ),
        );
      },
    );
  }
}
