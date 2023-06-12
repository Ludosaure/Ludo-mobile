import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class CartContent extends StatelessWidget {
  final List<Game> cartContent;
  final double totalAmount;

  const CartContent({
    Key? key,
    required this.cartContent,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartContent.length + 1, // +1 for the total amount
      itemBuilder: (context, index) {
        if(index == cartContent.length) {
          return _buildTotalAmount(totalAmount);
        }
        final Game game = cartContent[index];
        return _buildCartItem(context, game);
      },
    );
  }

  Widget _buildCartItem(BuildContext context, Game game) {
    Widget leading = const FaIcon(
      FontAwesomeIcons.diceD20,
      color: Colors.grey,
    );

    return ListTile(
      leading: leading,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: () {
              context.push('${Routes.game.path}/${game.id}');
            },
            child: Text(
              game.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const Spacer(),
          Text(
            '${game.weeklyAmount} €',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalAmount(double totalAmount) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Divider(),
        const SizedBox(height: 10),
        Row(
          children: [
            const Text(
              "Montant total de la réservation",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const Spacer(),
            Text(
              "$totalAmount €",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
