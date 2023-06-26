import 'package:easy_localization/easy_localization.dart';
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
          'cart-title',
          style: TextStyle(color: Colors.black),
        ).tr(),
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
        : BlocConsumer<CartCubit, CartState>(
            listener: (context, state) {
              if (state is CartContentLoaded ||
                  state is PaymentCompleted) {
                setState(() {
                  cartContent = state.cartContent;
                });
              }

              if (state is LoadCartContentError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }

              if (state is PaymentTooHigh) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }

              if (state is PaymentPresentFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }

              if (state is PaymentFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is CartContentLoaded ||
                  state is PaymentCanceled ||
                  state is PaymentTooHigh) {

                cartContent = state.cartContent;

                if (state.cartContent.isEmpty) {
                  return Center(
                    child: const Text("cart-empty-label").tr(),
                  );
                }

                final paymentTooHigh = state is PaymentTooHigh;

                final totalAmount =
                    context.read<CartCubit>().getCartTotalAmount();

                return Column(
                    mainAxisSize: MainAxisSize.min,
                    verticalDirection: VerticalDirection.down,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: CartContent(
                          cartContent: cartContent,
                          totalAmount: totalAmount,
                          bookingPeriod: state.bookingPeriod,
                          reduction: state.reduction,
                        ),
                      ),
                      _buildBookingPeriodInformation(context),
                      _buildValidateReservationButton(context, paymentTooHigh),
                    ]);
              }

              if (state is PaymentCompleted) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 75,
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "payment-success-label",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ).tr(),
                    const SizedBox(height: 40),
                    const Text(
                      "payment-success-subtitle",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ).tr(),
                  ],
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
  }

  Widget _buildBookingPeriodInformation(context) {
    if (cartContent.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const Text(
            "booking-nb-weeks-information",
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.end,
          ).tr(),
        ),
      );
    }

    return const SizedBox();
  }

  Widget _buildValidateReservationButton(
    BuildContext context,
    bool paymentTooHigh,
  ) {
    if (cartContent.isNotEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            alignment: Alignment.center,
          ),
          onPressed: paymentTooHigh ? null : _onValidatePressed,
          child: const Text('payment-validate-button').tr(),
        ),
      );
    }

    return const SizedBox();
  }

  void _onValidatePressed() async {
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
  }
}
