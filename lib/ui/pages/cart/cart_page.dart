import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/use_cases/cart/cart_cubit.dart';
import 'package:ludo_mobile/ui/pages/cart/cart_content.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class CartPage extends StatefulWidget {
  const CartPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Game> cartContent = [];
  late bool paymentSheetDisplayed = false;

  @override
  void initState() {
    BlocProvider.of<CartCubit>(context).getCartContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: ResponsiveWrapper.of(context).isSmallerThan(TABLET) ||
                !paymentSheetDisplayed
            ? BackButton(
                color: Colors.black,
                onPressed: () {
                  Stripe.instance.resetPaymentSheetCustomer();
                  context.go(Routes.home.path);
                },
              )
            : null,
        title: const Text(
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

  Widget? _buildMobileCartContent(BuildContext context) {
    return paymentSheetDisplayed
        ? null
        : Column(
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: BlocConsumer<CartCubit, CartState>(
                  listener: (context, state) {
                    if (state is CartContentLoaded) {
                      setState(() {
                        cartContent = state.cartContent;
                      });
                    }

                    if(state is PaymentCompleted) {
                      setState(() {
                        cartContent = state.cartContent;
                      });
                    }
                  },
                  builder: (context, state) {
                    if (state is CartContentLoaded ||
                        state is PaymentCanceled ||
                        state is PaymentPresentFailed) {
                      if (cartContent.isEmpty) {
                        return const Center(
                          child: Text("Votre panier est vide"),
                        );
                      }
                      final totalAmount =
                          context.read<CartCubit>().getCartTotalAmount();

                      return CartContent(
                        cartContent: cartContent,
                        totalAmount: totalAmount,
                      );
                    }

                    if (state is PaymentCompleted) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 75,
                          ),
                          SizedBox(height: 40),
                          Text(
                            "Votre paiement a bien été pris en compte.",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 40),
                          Text(
                            "Il ne vous reste plus qu'à venir chercher votre jeu !",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              _buildValidateReservationButton(context),
            ],
          );
  }

  Widget _buildValidateReservationButton(BuildContext context) {
    if (cartContent.isNotEmpty) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
        ),
        onPressed: () async {
          setState(() {
            paymentSheetDisplayed = true;
          });
          try {
            await context.read<CartCubit>().displayPaymentSheet();
          } catch (e) {
            //TODO
            print(e);
          }

          setState(() {
            paymentSheetDisplayed = false;
          });
        },
        child: const Text('Valider la commande'),
      );
    }

    return const SizedBox();
  }
}
