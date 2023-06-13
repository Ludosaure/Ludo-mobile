import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/use_cases/cart/cart_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/favorite_games/favorite_games_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/get_game/get_game_cubit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ludo_mobile/domain/use_cases/list_reduction_plan/list_reduction_plan_cubit.dart';
import 'package:ludo_mobile/ui/components/expandable_text_widget.dart';
import 'package:ludo_mobile/ui/components/favorite_button.dart';
import 'package:ludo_mobile/ui/pages/game/detail/game_details_bottom_bar.dart';
import 'package:responsive_framework/responsive_framework.dart';

class GameDetailsPage extends StatelessWidget {
  final String gameId;
  late Game game;

  GameDetailsPage({Key? key, required this.gameId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocConsumer<GetGameCubit, GetGameState>(
        builder: (context, state) {
          if (state is GetGameInitial) {
            BlocProvider.of<GetGameCubit>(context).getGame(gameId);
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GetGameLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is GetGameSuccess) {
            game = state.game;

            return ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                ? _buildMobileGameContent(context)
                : _buildDesktopGameContent(context);
          }

          return Container();
        },
        listener: (context, state) {
          if (state is GetGameError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildDesktopGameContent(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: SizedBox(
            width: size.width * 0.30,
            height: size.height * 0.70,
            child: _buildGameImage(context),
          ),
        ),
        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.30,
          child: SizedBox(
            width: size.width * 0.65,
            child: _buildNameAndFavorite(context),
          ),
        ),
        Positioned(
          top: size.height * 0.20,
          left: size.width * 0.30,
          child: SizedBox(
            width: size.width * 0.65,
            child: _buildGameDescription(context),
          ),
        ),
        Positioned(
          top: size.height * 0.40,
          left: size.width * 0.30,
          child: _buildGameRating(context),
        ),
        Positioned(
          top: size.height * 0.50,
          left: size.width * 0.30,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: context.read<CartCubit>(),
              ),
              BlocProvider.value(
                value: context.read<ListReductionPlanCubit>(),
              ),
            ],
            child: GameDetailsBottomBar(
              game: game,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileGameContent(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: _buildGame(context),
          ),
          const SizedBox(
            height: 10,
          ),
          MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: context.read<CartCubit>(),
              ),
              BlocProvider.value(
                value: context.read<ListReductionPlanCubit>(),
              ),
            ],
            child: GameDetailsBottomBar(
              game: game,
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
          ? Colors.transparent
          : Theme.of(context).colorScheme.secondary,
      elevation: 0,
      leading: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
          ? BackButton(
              color: Colors.black,
              onPressed: () {
                context.pop();
              },
            )
          : null,
      leadingWidth: MediaQuery.of(context).size.width * 0.20,
    );
  }

  Widget _buildGame(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      verticalDirection: VerticalDirection.down,
      children: [
        _buildGameImage(context),
        const SizedBox(height: 8),
        _buildNameAndFavorite(context),
        _buildGameDescription(context),
        _buildGameRating(context),
      ],
    );
  }

  Widget _buildNameAndFavorite(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          game.name,
          style: TextStyle(
            fontSize: ResponsiveValue(
              context,
              defaultValue: 16.0,
              valueWhen: [
                const Condition.smallerThan(name: TABLET, value: 16.0),
                const Condition.largerThan(name: TABLET, value: 20.0),
                const Condition.largerThan(name: DESKTOP, value: 24.0),
              ],
            ).value,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        BlocProvider.value(
          value: context.read<FavoriteGamesCubit>(),
          child: FavoriteButton(
            game: game,
          ),
        ),
      ],
    );
  }

  Widget _buildGameImage(BuildContext context) {
    if (game.imageUrl != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image(
          image: NetworkImage(game.imageUrl!),
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width,
        ),
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

  Widget _buildGameRating(BuildContext context) {
    if (game.rating == 0) {
      return const Text("");
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RatingBar.builder(
          initialRating: game.rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          unratedColor: Colors.amberAccent.withOpacity(0.3),
          itemSize: 30,
          itemBuilder: (context, _) {
            return const Icon(
              Icons.star,
              color: Colors.amber,
            );
          },
          onRatingUpdate: (rating) {
            //todo
          },
        ),
        const SizedBox(width: 8),
        Text(
          game.rating.toString(),
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildGameDescription(BuildContext context) {
    if (game.description == null) {
      return const Flexible(
        child: SizedBox(width: 8),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      verticalDirection: VerticalDirection.down,
      children: [
        ExpandableTextWidget(
          text: game.description!,
          height: MediaQuery.of(context).size.height * 0.25,
        ),
      ],
    );
  }
}