import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/payment_provider.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:meta/meta.dart';

part 'cart_state.dart';

@singleton
class CartCubit extends Cubit<CartState> {
  final PaymentProvider _paymentProvider;

  //TODO mettre dans le state de ses morts
  final int _nbWeek = 2;

  CartCubit(this._paymentProvider) : super(AddToCartInitial());

  bool isGameInCart(String gameId) {
    return state.cartContent.any((game) => game.id == gameId);
  }

  void addToCart(Game game) async {
    emit(AddToCartLoading(content: state.cartContent));
    await Future.delayed(const Duration(seconds: 2), () {
      emit(AddToCartSuccess(content: state.cartContent + [game]));
    });
  }

  void removeFromCart(String gameId) async {
    emit(AddToCartLoading(content: state.cartContent));
    await Future.delayed(const Duration(seconds: 2), () {
      final content =
          state.cartContent.where((element) => element.id != gameId).toList();
      emit(RemoveFromCartSuccess(content: content));
    });
  }

  // ?
  void onChangeDate(event, Emitter emit) async {
    print('loading');
    emit(AddToCartLoading(content: state.cartContent));
    await Future.delayed(const Duration(seconds: 2), () {
      print('success');
      emit(RemoveFromCartSuccess(content: state.cartContent + [event.gameId]));
    });
  }

  void getCartContent() async {
    if (state.cartContent.isEmpty) {
      Future.delayed(const Duration(seconds: 0), () {
        emit(CartContentLoaded(content: state.cartContent));
      });

      return;
    }

    _initPaymentSheet().then((void value) {
      Future.delayed(const Duration(seconds: 0), () {
        emit(CartContentLoaded(content: state.cartContent));
      });
    }).catchError((error) {
      emit(LoadCartContentError(
          error: "Erreur lors de la récupération du panier",
          content: state.cartContent));
    });
  }

  double getCartTotalAmount() {
    double amount = 0;
    state.cartContent.forEach((element) {
      amount += element.weeklyAmount;
    });

    return amount * _nbWeek;
  }

  Future<void> _initPaymentSheet() async {
    // 1. create payment intent
    final paymentIntent =
        await _paymentProvider.createPaymentIntent(getCartTotalAmount());

    // 2. initialize the payment sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        customFlow: true,
        merchantDisplayName: AppConstants.STRIPE_MERCHANT_ID,
        paymentIntentClientSecret: paymentIntent.clientSecret,
        customerId: paymentIntent.customerId,
        style: ThemeMode.light,
        billingDetails: const BillingDetails(
          address: Address(
            city: null,
            country: 'FR',
            line1: null,
            line2: null,
            postalCode: null,
            state: null,
          ),
        ),
      ),
    );
  }

  Future<void> displayPaymentSheet() async {
    Stripe.instance
        .presentPaymentSheet(
      options: const PaymentSheetPresentOptions(),
    )
        // Cas de succès
        .then((void value) async {
      emit(PaymentSheetDisplayed(content: state.cartContent));
      await _confirmPayment();
    }, onError: (e) {
      if (e is StripeException && e.error.code == FailureCode.Canceled) {
        emit(PaymentCanceled(content: state.cartContent));
        return;
      }
      emit(
        PaymentPresentFailed(
          message: "Erreur lors de l'affichage du paiement",
          content: state.cartContent,
        ),
      );
    }).whenComplete(
      () {
        Stripe.instance.resetPaymentSheetCustomer();
      },
    );
  }

  Future<void> _confirmPayment() async {
    Stripe.instance
        .confirmPaymentSheetPayment()
        .then((value) {
          emit(
            PaymentCompleted(content: List.empty()),
          );
        })
        .catchError((error) {
          emit(
            PaymentFailed(
              message: "Erreur lors de la confirmation du paiement",
              content: state.cartContent,
            ),
          );
        });
  }
}
