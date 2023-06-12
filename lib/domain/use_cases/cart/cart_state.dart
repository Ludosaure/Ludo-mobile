part of 'cart_cubit.dart';

@immutable
abstract class CartState {
  final List<Game> cartContent;
  final DateTimeRange bookingPeriod;

  const CartState({
    required this.cartContent,
    required this.bookingPeriod,
  });
}

class AddToCartInitial extends CartState {
  AddToCartInitial()
      : super(
          cartContent: List.empty(),
          bookingPeriod: DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 7)),
          ),
        );
}

class BookingOperationLoading extends CartState {
  const BookingOperationLoading({
    required List<Game> content,
    required DateTimeRange bookingPeriod,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
        );
}

class BookingOperationSuccess extends CartState {
  const BookingOperationSuccess({
    required List<Game> content,
    required DateTimeRange bookingPeriod,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
        );
}

class BookingOperationFailure extends CartState {
  final String message;

  const BookingOperationFailure({
    required this.message,
    required List<Game> content,
    required DateTimeRange bookingPeriod,
  }) : super(
    cartContent: content,
    bookingPeriod: bookingPeriod,
  );
}

class BookingDateUpdated extends CartState {
  const BookingDateUpdated({
    required List<Game> content,
    required DateTimeRange bookingPeriod,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
        );
}

class CartContentLoaded extends CartState {
  const CartContentLoaded({
    required List<Game> content,
    required DateTimeRange bookingPeriod,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
        );
}

class LoadCartContentError extends CartState {
  final String error;

  const LoadCartContentError({
    required this.error,
    required List<Game> content,
    required DateTimeRange bookingPeriod,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
        );
}

class PaymentSheetDisplayed extends CartState {
  const PaymentSheetDisplayed({
    required List<Game> content,
    required DateTimeRange bookingPeriod,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
        );
}

class PaymentCompleted extends CartState {
  const PaymentCompleted({
    required List<Game> content,
    required DateTimeRange bookingPeriod,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
        );
}

class PaymentPresentFailed extends CartState {
  final String error;

  const PaymentPresentFailed({
    required this.error,
    required List<Game> content,
    required DateTimeRange bookingPeriod,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
        );
}

class PaymentFailed extends CartState {
  final String error;

  const PaymentFailed({
    required this.error,
    required List<Game> content,
    required DateTimeRange bookingPeriod,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
        );
}

class PaymentCanceled extends CartState {
  const PaymentCanceled({
    required List<Game> content,
    required DateTimeRange bookingPeriod,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
        );
}

class UserNotLogged extends CartState {
  UserNotLogged()
      : super(
          cartContent: List.empty(),
          bookingPeriod: DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 7)),
          ),
        );
}
