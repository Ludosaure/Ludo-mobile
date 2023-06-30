import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/review.dart';
import 'package:ludo_mobile/ui/pages/reviews/comment_tile.dart';

class ReviewList extends StatelessWidget {
  final List<Review> reviews;

  const ReviewList({
    required this.reviews,
    super.key,
  });

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
      children: reviews
          .map(
            (review) => CommentTile(
          review: review,
        ),
      )
          .toList(),
    );
  }
}
