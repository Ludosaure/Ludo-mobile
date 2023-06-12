part of 'cart_cubit.dart';

@immutable
abstract class CartState {
  final List<Game> cartContent;

  const CartState({
    required this.cartContent,
  });
}

class AddToCartInitial extends CartState {
  AddToCartInitial() : super(cartContent: List.empty());
}

class AddToCartLoading extends CartState {
  const AddToCartLoading({
    required List<Game> content,
  }) : super(cartContent: content);
}

class AddToCartSuccess extends CartState {
  const AddToCartSuccess({
    required List<Game> content,
  }) : super(cartContent: content);
}

class RemoveFromCartSuccess extends CartState {
  const RemoveFromCartSuccess({
    required List<Game> content,
  }) : super(cartContent: content);
}

class CartContentLoaded extends CartState {
  const CartContentLoaded({
    required List<Game> content,
  }) : super(cartContent: content);
}

class LoadCartContentError extends CartState {
  final String error;

  const LoadCartContentError({
    required this.error,
    required List<Game> content,
  }) : super(cartContent: content);
}

class AddToCartFailure extends CartState {
  final String message;

  const AddToCartFailure({
    required this.message,
    required List<Game> content,
  }) : super(cartContent: content);
}

class PaymentSheetDisplayed extends CartState {
  const PaymentSheetDisplayed({
    required List<Game> content,
  }) : super(cartContent: content);
}

class PaymentCompleted extends CartState {
  const PaymentCompleted({
    required List<Game> content,
  }) : super(cartContent: content);
}

class PaymentPresentFailed extends CartState {
  final String message;

  const PaymentPresentFailed({
    required this.message,
    required List<Game> content,
  }) : super(cartContent: content);
}

class PaymentFailed extends CartState {
  final String message;

  const PaymentFailed({
    required this.message,
    required List<Game> content,
  }) : super(cartContent: content);
}

class PaymentCanceled extends CartState {
  const PaymentCanceled({
    required List<Game> content,
  }) : super(cartContent: content);
}


class UserNotLogged extends CartState {
  UserNotLogged() : super(cartContent: List.empty());
}
