import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
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

  CartCubit(this._paymentProvider) : super(AddToCartInitial());

  bool isGameInCart(String gameId) {
    return state.cartContent.any((game) => game.id == gameId);
  }

  DateTimeRange getBookingPeriod() {
    return state.bookingPeriod;
  }

  void addToCart(Game game, DateTimeRange selectedPeriod) async {
    emit(
      BookingOperationLoading(
        content: state.cartContent,
        bookingPeriod: selectedPeriod,
      ),
    );
    await Future.delayed(const Duration(seconds: 2), () {
      emit(
        BookingOperationSuccess(
          content: state.cartContent + [game],
          bookingPeriod: selectedPeriod,
        ),
      );
    });
  }

  void removeFromCart(String gameId) async {
    emit(
      BookingOperationLoading(
        content: state.cartContent,
        bookingPeriod: state.bookingPeriod,
      ),
    );
    await Future.delayed(const Duration(seconds: 2), () {
      final content = state.cartContent.where((element) {
        return element.id != gameId;
      }).toList();

      emit(
        BookingOperationSuccess(
          content: content,
          bookingPeriod: state.bookingPeriod,
        ),
      );
    });
  }

  void onChangeDate(DateTimeRange bookingPeriod) async {
    print('loading');
    emit(
      BookingOperationLoading(
        content: state.cartContent,
        bookingPeriod: bookingPeriod,
      ),
    );
    await Future.delayed(const Duration(seconds: 0), () {
      print('success');
      emit(
        BookingDateUpdated(
          content: state.cartContent,
          bookingPeriod: bookingPeriod,
        ),
      );
    });
  }

  void getCartContent() async {
    if (state.cartContent.isEmpty) {
      Future.delayed(const Duration(seconds: 0), () {
        emit(
          CartContentLoaded(
            content: state.cartContent,
            bookingPeriod: state.bookingPeriod,
          ),
        );
      });

      return;
    }

    _initPaymentSheet().then((void value) {
      Future.delayed(const Duration(seconds: 0), () {
        emit(
          CartContentLoaded(
            content: state.cartContent,
            bookingPeriod: state.bookingPeriod,
          ),
        );
      });
    }).catchError((error) {
      print(error);
      emit(
        LoadCartContentError(
          error: "errors.cart-loading".tr(),
          content: state.cartContent,
          bookingPeriod: state.bookingPeriod,
        ),
      );
    });
  }

  double getCartTotalAmount() {
    double amount = 0;
    state.cartContent.forEach((element) => amount += element.weeklyAmount);

    int nbWeek = (state.bookingPeriod.duration.inDays / 7).ceil();
    nbWeek == 0 ? nbWeek = 1 : nbWeek = nbWeek;

    return amount * nbWeek;
  }

  Future<void> displayPaymentSheet() async {
    Stripe.instance
        .presentPaymentSheet(
      options: const PaymentSheetPresentOptions(),
    )
        // Cas de succès
        .then((void value) async {
      emit(
        PaymentSheetDisplayed(
          content: state.cartContent,
          bookingPeriod: state.bookingPeriod,
        ),
      );
      await _confirmPayment();
    }, onError: (e) {
      if (e is StripeException && e.error.code == FailureCode.Canceled) {
        emit(
          PaymentCanceled(
            content: state.cartContent,
            bookingPeriod: state.bookingPeriod,
          ),
        );
        return;
      }
      emit(
        PaymentPresentFailed(
          error: "errors.payment-sheet-display".tr(),
          content: state.cartContent,
          bookingPeriod: state.bookingPeriod,
        ),
      );
    }).whenComplete(
      () {
        Stripe.instance.resetPaymentSheetCustomer();
      },
    );
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

  Future<void> _confirmPayment() async {
    Stripe.instance.confirmPaymentSheetPayment().then((value) {
      emit(
        PaymentCompleted(
          content: List.empty(),
          bookingPeriod: DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 7)),
          ),
        ),
      );
    }).catchError((error) {
      emit(
        PaymentFailed(
          error: "errors.payment-sheet-submit".tr(),
          content: state.cartContent,
          bookingPeriod: state.bookingPeriod,
        ),
      );
    });
  }
}
