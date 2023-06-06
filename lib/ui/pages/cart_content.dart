import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class CartContent extends StatelessWidget {
  final List<String> cartContent;

  const CartContent({
    Key? key,
    required this.cartContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartContent.length,
      itemBuilder: (context, index) {
        final String gameId = cartContent[index];
        return GestureDetector(
          onTap: () {
            context.push(
              '${Routes.game.path}/$gameId',
            );
          },
          child: _buildCartItem(context, gameId),
        );
      },
    );
  }

  Widget _buildCartItem(BuildContext context, String id) {
    Widget leading = const FaIcon(
      FontAwesomeIcons.diceD20,
      color: Colors.grey,
    );

    return ListTile(
      leading: leading,
      title: Text(id),
    );

  }
}
