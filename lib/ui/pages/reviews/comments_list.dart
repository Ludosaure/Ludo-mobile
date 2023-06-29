import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/review.dart';
import 'package:ludo_mobile/ui/pages/reviews/comment_tile.dart';

class CommentsList extends StatelessWidget {
  final List<Review> reviews;

  const CommentsList({
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
      children: [
        const SizedBox(height: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Text(
            "Commentaires",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalDirection: VerticalDirection.down,
          children: [
            CommentTile(review: reviews[0]),
            CommentTile(review: reviews[1]),
          ],
        )
      ],
    );
  }
}
