
import 'package:flutter/material.dart';
import 'package:ludo_mobile/ui/components/custom_rating_bar.dart';
import 'package:ludo_mobile/ui/components/form_field_decoration.dart';

class ReviewForm extends StatelessWidget {
  const ReviewForm({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildForm(context);
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        children: [
          CustomRatingBar(
            initialRating: 1,
            ignoreGestures: false,
            itemSize: 30,
            onRatingUpdate: (rating) {
              print("rating: $rating");
            },
          ),
          TextFormField(
            decoration: FormFieldDecoration.textArea("Donnez nous votre avis sur ce jeu."),
            maxLines: 10,
            onChanged: (value) {
              print("value: $value");
            },
          )
        ],
      ),
    );
  }
}
