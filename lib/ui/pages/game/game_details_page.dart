import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/use_cases/favorite_games/favorite_games_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/get_game/get_game_cubit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ludo_mobile/ui/components/custom_back_button.dart';
import 'package:ludo_mobile/ui/components/expandable_text_widget.dart';
import 'package:ludo_mobile/ui/components/favorite_button.dart';
import 'package:ludo_mobile/utils/app_dimensions.dart';
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
          child: _buildGameDetailsBottomBar(context),
        ),
      ],
    );
  }

  Widget _buildMobileGameContent(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SizedBox(
        height: MediaQuery.of(context).size.height -
            MediaQuery.of(context).size.height * 0.06,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              child: _buildGame(context),
            ),
            const Spacer(),
            _buildGameDetailsBottomBar(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    if (ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)) {
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomBackButton(),
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.20,
      );
    }
    return null;
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

  Widget _buildGameDetailsBottomBar(BuildContext context) {
    return Container(
      height: ResponsiveValue(
        context,
        defaultValue: 150.0,
        valueWhen: [
          const Condition.smallerThan(name: TABLET, value: 175.0), //mobile
          const Condition.largerThan(name: MOBILE, value: 225.0), //tablet
          const Condition.largerThan(name: TABLET, value: 250.0), //desktop
          const Condition.largerThan(name: DESKTOP, value: 300.0), //large desktop
          Condition.largerThan(name: AppDimensions.LARGE_DESKTOP, value: 350.0), //4k
        ],
      ).value,
      width: ResponsiveValue(
        context,
        defaultValue: MediaQuery.of(context).size.width,
        valueWhen: [
          Condition.smallerThan(
            name: DESKTOP,
            value: MediaQuery.of(context).size.width,
          ),
          Condition.largerThan(
            name: TABLET,
            value: MediaQuery.of(context).size.width * 0.60,
          ),
        ],
      ).value,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.88),
        borderRadius: BorderRadius.vertical(
          top: const Radius.circular(30),
          bottom: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
              ? const Radius.circular(0)
              : const Radius.circular(30),
        ),
      ),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: ResponsiveValue(
            context,
            defaultValue: 1.5,
            valueWhen: [
              const Condition.smallerThan(name: TABLET, value: 1.5), // mobile
              const Condition.largerThan(name: MOBILE, value: 2.5), // tablet
              const Condition.largerThan(name: TABLET, value: 2.0), // desktop
              const Condition.largerThan(name: DESKTOP, value: 2.7), // large desktop
              Condition.largerThan(name: AppDimensions.LARGE_DESKTOP, value: 3.0), // 4k
            ],
          ).value!,
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
                "nb-players-label-long",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ).tr(),
              const SizedBox(height: 8),
              const Text(
                "min-max-players-label",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ).tr(namedArgs: {
                "minPlayers": game.minPlayers.toString(),
                "maxPlayers": game.maxPlayers.toString(),
              }),
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
                "min-age-label",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ).tr(),
              const SizedBox(height: 8),
              const Text(
                "min-age",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ).tr(namedArgs: {
                "age": game.minAge.toString(),
              }),
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
                "game-duration-label",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ).tr(),
              const SizedBox(height: 8),
              const Text(
                "game-duration",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ).tr(namedArgs: {
                "duration": game.averageDuration.toString(),
              }),
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
                "weekly-amount-label",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ).tr(),
              const SizedBox(height: 8),
              const Text(
                "weekly-amount",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(namedArgs: {
                "amount": game.weeklyAmount.toString(),
              }),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(75, 20),
                maximumSize: const Size(75, 40),
                padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                visualDensity: VisualDensity.compact,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.88),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {},
              child: const Text("book-game-label").tr(),
            ),
          ),
        ],
      ),
    );
  }
}
