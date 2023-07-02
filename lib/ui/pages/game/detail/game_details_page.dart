import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/cart/cart_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/favorite_games/favorite_games_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/get_game/get_game_cubit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ludo_mobile/domain/use_cases/list_reduction_plan/list_reduction_plan_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/review_game/review_game_cubit.dart';
import 'package:ludo_mobile/ui/components/custom_rating_bar.dart';
import 'package:ludo_mobile/ui/components/expandable_text_widget.dart';
import 'package:ludo_mobile/ui/components/favorite_button.dart';
import 'package:ludo_mobile/ui/pages/game/detail/game_booking_component.dart';
import 'package:ludo_mobile/ui/pages/game/detail/game_details_info_bar.dart';
import 'package:ludo_mobile/ui/pages/reviews/review_section_component.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:responsive_framework/responsive_framework.dart';

class GameDetailsPage extends StatelessWidget {
  final User? user;
  final String gameId;
  late Game game;

  GameDetailsPage({
    Key? key,
    required this.gameId,
    this.user,
  }) : super(key: key);

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
            context.read<ReviewGameCubit>().changeGame(game.reviews);

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
          top: 90,
          left: 0,
          child: SizedBox(
            width: size.width * 0.25,
            height: 200,
            child: _buildGameImage(context),
          ),
        ),
        Positioned(
          top: 80,
          left: size.width * 0.25,
          child: SizedBox(
            width: size.width * 0.65,
            child: _buildNameAndFavorite(context),
          ),
        ),
        Positioned(
          top: 130,
          left: size.width * 0.25,
          child: GameDetailsInfoBar(
            game: game,
          ),
        ),
        Positioned(
          top: 235,
          left: size.width * 0.25,
          child: _buildGameRating(context),
        ),
        Positioned(
          top: 280,
          left: size.width * 0.25,
          child: SizedBox(
            width: size.width * 0.30,
            child: _buildGameDescription(context),
          ),
        ),
        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.60,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: context.read<CartCubit>(),
              ),
              BlocProvider.value(
                value: context.read<ListReductionPlanCubit>(),
              ),
            ],
            child: SizedBox(
              width: size.width * 0.35,
              child: GameBookingComponent(
                user: user,
                game: game,
              ),
            ),
          ),
        ),
        Positioned(
          top: (user != null && !user!.isAdmin())
              ? size.height * 0.25
              : size.height * 0.18,
          left: size.width * 0.60,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
              width: size.width * 0.35,
              child: ReviewSectionComponent(
                isUserLoggedIn: user != null,
                game: game,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileGameContent(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: [
            _buildGameImage(context),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Center(
                child: _buildGameRating(context),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildNameAndFavorite(context),
            const SizedBox(height: 8),
            MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: context.read<CartCubit>(),
                ),
                BlocProvider.value(
                  value: context.read<ListReductionPlanCubit>(),
                ),
              ],
              child: GameBookingComponent(
                user: user,
                game: game,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _buildGameDescription(context),
            const SizedBox(
              height: 10,
            ),
            GameDetailsInfoBar(
              game: game,
            ),
            const SizedBox(
              height: 10,
            ),
            ReviewSectionComponent(
              isUserLoggedIn: user != null,
              game: game,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor:
          ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) && !kIsWeb
              ? Colors.transparent
              : Theme.of(context).colorScheme.secondary,
      elevation: 0,
      title: kIsWeb ? const Text(AppConstants.APP_NAME) : null,
      leading: BackButton(
        color: kIsWeb ? Colors.white : Colors.black,
        onPressed: () {
          if (Navigator.of(context).canPop()) {
            context.pop();
          } else {
            context.go(Routes.home.path);
          }
        },
      ),
      leadingWidth: MediaQuery.of(context).size.width * 0.20,
    );
  }

  Widget _buildNameAndFavorite(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          game.name,
          softWrap: true,
          overflow: TextOverflow.visible,
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
        padding: const EdgeInsets.all(16.0),
        child: Image(
          image: NetworkImage(game.imageUrl!),
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height * 0.20,
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

    return BlocBuilder<ReviewGameCubit, ReviewGameState>(
      builder: (context, state) {
        if (state is ReviewGameSuccess) {
          final double averageRating = state.reviews
                  .map((review) => review.rating)
                  .reduce((value, element) => value + element) /
              state.reviews.length;

          return CustomRatingBar(
            allowHalfRating: true,
            initialRating: averageRating,
            ignoreGestures: true,
            itemSize: 30,
            onRatingUpdate: (rating) {},
          );
        }
        return CustomRatingBar(
          allowHalfRating: true,
          initialRating: game.rating,
          ignoreGestures: true,
          itemSize: 30,
          onRatingUpdate: (rating) {},
        );
      },
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
