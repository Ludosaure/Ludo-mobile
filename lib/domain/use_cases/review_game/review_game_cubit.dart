import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/data/repositories/review_repository.dart';
import 'package:ludo_mobile/domain/models/review.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:meta/meta.dart';

part 'review_game_state.dart';

@singleton
class ReviewGameCubit extends Cubit<ReviewGameState> {
  final SessionCubit _sessionCubit;
  final ReviewRepository _reviewRepository;

  ReviewGameCubit(
    this._sessionCubit,
    this._reviewRepository,
  ) : super(const ReviewGameInitial([]));

  void submitReview({
    String? comment,
    required int rating,
    required String gameId,
  }) async {
    List<Review> reviews = state.reviews;

    emit(const ReviewGameSubmitting());
    try {
      await _reviewRepository.reviewGame(
        gameId,
        rating,
        comment,
      );
    } catch (exception) {
      if (exception is UserNotLoggedInException ||
          exception is ForbiddenException) {
        _sessionCubit.logout();
        emit(
          UserMustLogError(
            message: exception.toString(),
          ),
        );
        return;
      }

      emit(
        ReviewGameError(message: exception.toString()),
      );
      return;
    }

    emit(
      ReviewGameSuccess(
        [
          ...reviews,
          Review(
            comment: comment,
            rating: rating,
            createdAt: DateTime.now(),
          ),
        ],
      ),
    );
  }

  void changeGame(List<Review> reviews) {
    emit(
      ReviewGameInitial(reviews),
    );
  }
}
