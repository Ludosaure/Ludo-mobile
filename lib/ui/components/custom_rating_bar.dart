import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomRatingBar extends StatelessWidget {
  final bool ignoreGestures;
  final double initialRating;
  final double itemSize;
  final void Function(double) onRatingUpdate;
  final bool allowHalfRating;

  const CustomRatingBar({
    required this.initialRating,
    required this.ignoreGestures,
    required this.itemSize,
    required this.onRatingUpdate,
    required this.allowHalfRating,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      ignoreGestures: ignoreGestures,
      initialRating: initialRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: allowHalfRating,
      itemCount: 5,
      unratedColor: Colors.amberAccent.withOpacity(0.3),
      itemSize: itemSize,
      itemBuilder: (context, _) {
        return const Icon(
          Icons.star,
          color: Colors.amber,
        );
      },
      onRatingUpdate: onRatingUpdate,
    );
  }
}
