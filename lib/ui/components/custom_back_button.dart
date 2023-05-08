import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class CustomBackButton extends StatelessWidget {
  final Color color;
  const CustomBackButton({Key? key, this.color = Colors.black}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.1,
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
            context.go(Routes.landing.path, extra: null);
          }
        },
        icon: Icon(Icons.arrow_back, color: color),
      ),
    );
  }
}
