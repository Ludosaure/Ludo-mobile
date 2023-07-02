import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/review.dart';
import 'package:ludo_mobile/ui/components/custom_rating_bar.dart';

class ReviewTile extends StatelessWidget {
  final Review review;

  const ReviewTile({
    required this.review,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCommentDisplay(context);
  }

  Widget _buildCommentDisplay(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2.0,
      shadowColor: Colors.grey.withOpacity(0.5),
      child: ListTile(
        visualDensity: VisualDensity.comfortable,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        leading: const SizedBox(
          height: double.infinity,
          child: Icon(Icons.person),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: [
            CustomRatingBar(
              allowHalfRating: false,
              initialRating: review.rating.toDouble(),
              ignoreGestures: true,
              itemSize: 15,
              onRatingUpdate: (rating) {},
            ),
            const SizedBox(width: 8),
            Text(
              _getCommentDate(review.createdAt),
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
        subtitle: review.comment != null
            ? Text(
                review.comment!,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 14,
                ),
              )
            : const SizedBox.shrink(),
        minVerticalPadding: 8,
      ),
    );
  }

  String _getCommentDate(DateTime date) {
    DateTime now = DateTime.now();
    if (now.difference(date).inDays > 1 && now.difference(date).inDays < 30) {
      return "il y a ${now.difference(date).inDays} jours";
    }

    if (now.difference(date).inDays == 1) {
      return "il y a 1 jour";
    }

    if (now.difference(date).inDays / 30 > 12) {
      return "il y a ${(now.difference(date).inDays / 30 / 12).ceil()} ans";
    }

    if (now.difference(date).inDays > 30) {
      return "il y a ${(now.difference(date).inDays / 30).ceil()} mois";
    }

    return "aujourd'hui";
  }
}
