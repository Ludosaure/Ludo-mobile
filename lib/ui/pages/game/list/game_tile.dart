import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/use_cases/delete_game/delete_game_cubit.dart';

class GameTile extends StatelessWidget {
  final Game game;
  final bool adminView;

  const GameTile({
    Key? key,
    required this.game,
    required this.adminView,
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
      trailing: _buildTrailing(context),
    );
  }

  Widget _buildTrailing(BuildContext context) {
    if (adminView) {
      return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'delete-game-label',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ).tr(),
                content: const Text(
                  'delete-game-confirmation',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ).tr(namedArgs: {'game': game.name}),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'cancel-label',
                      style: Theme.of(context).textTheme.button,
                    ).tr(),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<DeleteGameCubit>().deleteGame(game.id);
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Supprimer',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ).tr(),
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(
          Icons.delete,
          color: Colors.grey,
        ),
      );
    } else {
      return Text(
        'amount',
        style: Theme.of(context).textTheme.titleMedium,
      ).tr(
        namedArgs: {
          'amount': game.weeklyAmount.toString(),
        },
      );
    }
  }
}
