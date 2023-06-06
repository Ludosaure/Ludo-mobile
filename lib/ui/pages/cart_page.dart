import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/ui/pages/cart_content.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  //TODO
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: ResponsiveWrapper.of(context).isSmallerThan(TABLET)
            ? BackButton(
                color: Colors.black,
                onPressed: () {
                  context.go(Routes.home.path);
                },
              )
            : null,
        title: Text(
          'Mes Commandes',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: _buildMobileCartContent(context),
      ),
    );
  }

  Widget _buildMobileCartContent(BuildContext context) {
    //TODO BlocProvider.of<GetGameCubit>(context).getGame(gameId);
    return Column(
      mainAxisSize: MainAxisSize.min,
      verticalDirection: VerticalDirection.down,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: CartContent(cartContent: ['1', '2', '3']),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            alignment: Alignment.center,
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Commande validée'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Text('Valider la commande'),
        ),
      ],
    );
  }
}
