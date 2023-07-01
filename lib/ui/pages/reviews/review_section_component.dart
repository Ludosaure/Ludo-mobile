import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/use_cases/review_game/review_game_cubit.dart';
import 'package:ludo_mobile/ui/pages/reviews/review_form.dart';
import 'package:ludo_mobile/ui/pages/reviews/review_list.dart';

class ReviewSectionComponent extends StatefulWidget {
  final bool isUserLoggedIn;
  final Game game;

  const ReviewSectionComponent({
    required this.game,
    required this.isUserLoggedIn,
    super.key,
  });

  @override
  State<ReviewSectionComponent> createState() => _ReviewSectionComponentState();
}

class _ReviewSectionComponentState extends State<ReviewSectionComponent> {
  late bool _canBeReviewed = widget.game.canBeReviewed;
  bool get _isUserLoggedIn => widget.isUserLoggedIn;

  @override
  Widget build(BuildContext context) {
    return _buildCommentSection(context);
  }

  Widget _buildCommentSection(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      verticalDirection: VerticalDirection.down,
      children: [
        const Divider(),
        const SizedBox(height: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: const Text(
            "review-title",
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ).tr(),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: _buildReviewSectionInfo(context),
        ),
        const SizedBox(height: 8),
        BlocConsumer<ReviewGameCubit, ReviewGameState>(
          listener: (context, state) {
            if (state is ReviewGameSuccess) {
              setState(() {
                _canBeReviewed = false;
              });
            }
          },
          builder: (context, state) {
            if (state is ReviewGameSuccess) {
              return ReviewList(
                reviews: state.reviews,
              );
            }

            return ReviewList(
              reviews: widget.game.reviews,
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        _buildReviewForm(context),
      ],
    );
  }

  Widget _buildReviewForm(BuildContext context) {
    if (_canBeReviewed) {
      return BlocProvider.value(
        value: context.read<ReviewGameCubit>(),
        child: ReviewForm(
          game: widget.game,
        ),
      );
    }

    return const SizedBox(
      height: 1,
    );
  }

  Widget _buildReviewSectionInfo(BuildContext context) {
    String commentSectionInfo =
        "must-have-account-to-review".tr();
    if (_isUserLoggedIn) {
      commentSectionInfo =
      "must-have-rented-game-to-review".tr();
    }
    return Text(
      commentSectionInfo,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontSize: 14,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
