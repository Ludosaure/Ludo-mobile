import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/data/providers/payment_provider.dart';
import 'package:ludo_mobile/data/repositories/reservation/new_reservation.dart';
import 'package:ludo_mobile/data/repositories/reservation/reservation_repository.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:meta/meta.dart';

part 'cart_state.dart';

@singleton
class CartCubit extends Cubit<CartState> {
  final SessionCubit _sessionCubit;
  final PaymentProvider _paymentProvider;
  final ReservationRepository _reservationRepository;
  bool _warningDisplayed = false;

  CartCubit(
    this._sessionCubit,
    this._paymentProvider,
    this._reservationRepository,
  ) : super(AddToCartInitial());

  bool isGameInCart(String gameId) {
    return state.cartContent.any((game) => game.id == gameId);
  }

  bool isCartEmpty() {
    return state.cartContent.isEmpty;
  }

  bool wasWarningDisplayed() {
    return _warningDisplayed;
  }

  void changeWarningDisplayed(bool wasDisplayed) {
    _warningDisplayed = wasDisplayed;
  }

  DateTimeRange getBookingPeriod() {
    return state.bookingPeriod;
  }

  void addToCart(Game game, DateTimeRange selectedPeriod, int reduction) async {
    emit(
      BookingOperationLoading(
        content: state.cartContent,
        bookingPeriod: selectedPeriod,
        reduction: reduction,
      ),
    );
    await Future.delayed(const Duration(seconds: 2), () {
      emit(
        BookingOperationSuccess(
          content: state.cartContent + [game],
          bookingPeriod: selectedPeriod,
          reduction: reduction,
        ),
      );
    });
  }

  void removeFromCart(String gameId) async {
    emit(
      BookingOperationLoading(
        content: state.cartContent,
        bookingPeriod: state.bookingPeriod,
        reduction: state.reduction,
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
          reduction: state.reduction,
        ),
      );
    });
  }

  void onChangeDate(DateTimeRange bookingPeriod, int reduction) async {
    emit(
      BookingOperationLoading(
        content: state.cartContent,
        bookingPeriod: bookingPeriod,
        reduction: reduction,
      ),
    );

    await Future.delayed(const Duration(seconds: 0), () {
      emit(
        BookingDateUpdated(
          content: state.cartContent,
          bookingPeriod: bookingPeriod,
          reduction: reduction,
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
            reduction: state.reduction,
          ),
        );
      });

      return;
    }

    final double amount = getCartTotalAmount();
    if(amount > AppConstants.MAX_TOTAL_AMOUNT) {
      emit(
        PaymentTooHigh(
          error: "errors.payment-threshold-exceeded".tr(),
          content: state.cartContent,
          bookingPeriod: state.bookingPeriod,
          reduction: state.reduction,
        ),
      );
      return;
    }

    _initPaymentSheet(amount).then((void value) {
      Future.delayed(const Duration(seconds: 0), () {
        emit(
          CartContentLoaded(
            content: state.cartContent,
            bookingPeriod: state.bookingPeriod,
            reduction: state.reduction,
          ),
        );
      });
    }).catchError((error) {
      if (error is UserNotLoggedInException) {
        emit(UserNotLogged());
        return;
      }

      emit(
        LoadCartContentError(
          error: "errors.cart-loading".tr(),
          content: state.cartContent,
          bookingPeriod: state.bookingPeriod,
          reduction: state.reduction,
        ),
      );
    });
  }

  double getCartTotalAmount() {
    double amount = 0;
    state.cartContent.forEach((element) => amount += element.weeklyAmount);

    int reduction = state.reduction;
    int nbWeek = (state.bookingPeriod.duration.inDays / 7).ceil();
    nbWeek == 0 ? nbWeek = 1 : nbWeek = nbWeek;

    return amount * nbWeek * (1 - reduction / 100);
  }

  Future<void> displayPaymentSheet() async {
    try {
      NewReservation reservation =
          await _reservationRepository.createReservation(
        state.bookingPeriod,
        state.cartContent,
      );

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
            reduction: state.reduction,
          ),
        );
        await _confirmPayment(reservation);
      }, onError: (error) {
        if (error is StripeException && error.error.code == FailureCode.Canceled) {
          _removeUnpaidReservation(reservation.id);
          emit(
            PaymentCanceled(
              content: state.cartContent,
              bookingPeriod: state.bookingPeriod,
              reduction: state.reduction,
            ),
          );
          return;
        }

        emit(
          PaymentPresentFailed(
            error: "errors.payment-sheet-display".tr(),
            content: state.cartContent,
            bookingPeriod: state.bookingPeriod,
            reduction: state.reduction,
          ),
        );
      }).whenComplete(
        () {
          Stripe.instance.resetPaymentSheetCustomer();
        },
      );
    } catch (error) {
      if (error is UserNotLoggedInException) {
        _sessionCubit.logout();
        emit(UserNotLogged());
        return;
      }

      emit(
        PaymentPresentFailed(
          error: error.toString(),
          content: state.cartContent,
          bookingPeriod: state.bookingPeriod,
          reduction: state.reduction,
        ),
      );
    }
  }

  Future<void> _initPaymentSheet(double amount) async {
    // 1. create payment intent
    final paymentIntent =
        await _paymentProvider.createPaymentIntent(amount);

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

  Future<void> _confirmPayment(NewReservation reservation) async {
    Stripe.instance.confirmPaymentSheetPayment().then((value) {
      try {
        _reservationRepository.confirmReservationPayment(reservation);
      } catch (error) {
        if (error is UserNotLoggedInException) {
          _sessionCubit.logout();
          emit(UserNotLogged());
          return;
        }

        emit(
          PaymentFailed(
            error: "errors.payment-sheet-submit".tr(),
            content: state.cartContent,
            bookingPeriod: state.bookingPeriod,
            reduction: state.reduction,
          ),
        );
      }

      emit(
        PaymentCompleted(
          content: List.empty(),
          bookingPeriod: DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 7)),
          ),
          reduction: 0,
        ),
      );
    }).catchError((error) {
      emit(
        PaymentFailed(
          error: "errors.payment-sheet-submit".tr(),
          content: state.cartContent,
          bookingPeriod: state.bookingPeriod,
          reduction: state.reduction,
        ),
      );
    });
  }

  Future<void> _removeUnpaidReservation(String reservationId) async {
    try {
      await _reservationRepository.removeUnpaidReservation(reservationId);
      // Stripe
      // curl -X POST https://api.stripe.com/v1/payment_intents/pi_1Gszg72eZvKYlo2CO4oPuG76/cancel \
      // -d "cancellation_reason"="abandoned" \
      //   -u sk_test_4eC39HqLyjWDarjtT1zdp7dc:
    } catch (error) {
      if (error is UserNotLoggedInException) {
        _sessionCubit.logout();
        emit(UserNotLogged());
        return;
      }

      emit(
        CancelReservationFailed(
          error: "errors.cancel-reservation".tr(),
          content: state.cartContent,
          bookingPeriod: state.bookingPeriod,
          reduction: state.reduction,
        ),
      );
    }
  }

  void clearCart() {
    emit(AddToCartInitial());
  }

  @override
  Future<void> close() {
    _sessionCubit.close();
    return super.close();
  }
}
