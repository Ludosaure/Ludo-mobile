part of 'cart_cubit.dart';

@immutable
abstract class CartState {
  final List<Game> cartContent;
  final DateTimeRange bookingPeriod;
  final int reduction;

  const CartState({
    required this.cartContent,
    required this.bookingPeriod,
    required this.reduction,
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
          reduction: 0,
        );
}

class BookingOperationLoading extends CartState {
  const BookingOperationLoading({
    required List<Game> content,
    required DateTimeRange bookingPeriod,
    required int reduction,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
          reduction: reduction,
        );
}

class BookingOperationSuccess extends CartState {
  const BookingOperationSuccess({
    required List<Game> content,
    required DateTimeRange bookingPeriod,
    required int reduction,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
          reduction: reduction,
        );
}

class BookingOperationFailure extends CartState {
  final String message;

  const BookingOperationFailure({
    required this.message,
    required List<Game> content,
    required DateTimeRange bookingPeriod,
    required int reduction,
  }) : super(
    cartContent: content,
    bookingPeriod: bookingPeriod,
    reduction: reduction,
  );
}

class BookingDateUpdated extends CartState {
  const BookingDateUpdated({
    required List<Game> content,
    required DateTimeRange bookingPeriod,
    required int reduction,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
          reduction: reduction,
        );
}

class CartContentLoaded extends CartState {
  const CartContentLoaded({
    required List<Game> content,
    required DateTimeRange bookingPeriod,
    required int reduction,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
          reduction: reduction,
        );
}

class LoadCartContentError extends CartState {
  final String error;

  const LoadCartContentError({
    required this.error,
    required List<Game> content,
    required DateTimeRange bookingPeriod,
    required int reduction,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
          reduction: reduction,
        );
}

class PaymentSheetDisplayed extends CartState {
  const PaymentSheetDisplayed({
    required List<Game> content,
    required DateTimeRange bookingPeriod,
    required int reduction,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
          reduction: reduction,
        );
}

class PaymentCompleted extends CartState {
  const PaymentCompleted({
    required List<Game> content,
    required DateTimeRange bookingPeriod,
    required int reduction,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
          reduction: reduction,
        );
}

class PaymentPresentFailed extends CartState {
  final String error;

  const PaymentPresentFailed({
    required this.error,
    required List<Game> content,
    required DateTimeRange bookingPeriod,
    required int reduction,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
          reduction: reduction,
        );
}

class PaymentFailed extends CartState {
  final String error;

  const PaymentFailed({
    required this.error,
    required List<Game> content,
    required DateTimeRange bookingPeriod,
    required int reduction,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
          reduction: reduction,
        );
}

class PaymentCanceled extends CartState {
  const PaymentCanceled({
    required List<Game> content,
    required DateTimeRange bookingPeriod,
    required int reduction,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
          reduction: reduction,
        );
}

class CancelReservationFailed extends CartState {
  final String error;

  const CancelReservationFailed({
    required List<Game> content,
    required DateTimeRange bookingPeriod,
    required int reduction,
    required this.error,
  }) : super(
          cartContent: content,
          bookingPeriod: bookingPeriod,
          reduction: reduction,
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
          reduction: 0,
        );
}
