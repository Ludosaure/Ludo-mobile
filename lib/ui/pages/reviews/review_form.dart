import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/use_cases/review_game/review_game_cubit.dart';
import 'package:ludo_mobile/ui/components/custom_rating_bar.dart';
import 'package:ludo_mobile/ui/components/form_field_decoration.dart';

class ReviewForm extends StatefulWidget {
  final Game game;

  const ReviewForm({
    required this.game,
    super.key,
  });

  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();

  Game get _game => widget.game;
  late int _rating = 1;
  late String _comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: BlocConsumer<ReviewGameCubit, ReviewGameState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ReviewGameSubmitting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ReviewGameSuccess) {
            return const SizedBox(
              width: 0,
              height: 0,
            );
          }

          if (state is ReviewGameError) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is ReviewGameInitial) {
            return _buildForm(context);
          }

          return const SizedBox(
            width: 0,
            height: 0,
          );
        },
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: [
          CustomRatingBar(
            allowHalfRating: false,
            initialRating: 1,
            ignoreGestures: false,
            itemSize: 30,
            onRatingUpdate: (rating) {
              _rating = rating.toInt();
            },
          ),
          const SizedBox(height: 12),
          _buildTextArea(context),
          const SizedBox(height: 12),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildTextArea(BuildContext context) {
    return TextField(
      decoration: FormFieldDecoration.textArea("review-field".tr()),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      onChanged: (value) {
        _comment = value;
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            context.read<ReviewGameCubit>().submitReview(
                  rating: _rating,
                  gameId: _game.id,
                  comment: _comment,
                );
          }
        },
        child: const Text(
          "review-submit-button",
          textAlign: TextAlign.center,
        ).tr(),
      ),
    );
  }
}
