part of 'review_game_cubit.dart';

@immutable
abstract class ReviewGameState {
  final List<Review> reviews;
  const ReviewGameState({
    this.reviews = const [],
  });
}

class ReviewGameInitial extends ReviewGameState {
  final List<Review> reviews;
  const ReviewGameInitial(this.reviews) : super();
}

class ReviewGameSubmitting extends ReviewGameState {
  const ReviewGameSubmitting() : super();
}

class ReviewGameSuccess extends ReviewGameState {
  final List<Review> reviews;
  const ReviewGameSuccess(this.reviews) : super();
}

class ReviewGameError extends ReviewGameState {
  final String message;

  const ReviewGameError({required this.message}) : super();
}

class UserMustLogError extends ReviewGameState {
  final String message;

  const UserMustLogError({required this.message}) : super();
}
