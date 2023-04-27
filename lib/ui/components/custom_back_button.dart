import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
      ),
      child: IconButton(
        splashRadius: 20,
        onPressed: () {
          if(Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/home',
              (Route<dynamic> route) => false,
            );
          }
        },
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }
}
