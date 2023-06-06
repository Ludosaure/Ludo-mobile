part of 'add_to_cart_bloc.dart';

@immutable
abstract class AddToCartEvent {
  final String gameId;
  const AddToCartEvent({required this.gameId});
}

class AddToCartSubmitEvent extends AddToCartEvent {
  const AddToCartSubmitEvent({required String gameId}) : super(gameId: gameId);
}

class RemoveFromCartSubmitEvent extends AddToCartEvent {
  const RemoveFromCartSubmitEvent({required String gameId})
      : super(gameId: gameId);
}
