part of 'add_to_cart_bloc.dart';

//TODO peut-être renommer
@immutable
abstract class AddToCartState {
  //TODO
  // Liste des identifiants des jeux
  final List<String> cartContent;

  const AddToCartState({
    required this.cartContent,
  });
}

class AddToCartInitial extends AddToCartState {
  AddToCartInitial() : super(cartContent: List.empty());
}

class AddToCartLoading extends AddToCartState {
  AddToCartLoading() : super(cartContent: List.empty());
}

class AddToCartSuccess extends AddToCartState {
  const AddToCartSuccess({
    required List<String> content,
  }) : super(cartContent: content);
}

class RemoveFromCartSuccess extends AddToCartState {
  const RemoveFromCartSuccess({
    required List<String> content,
  }) : super(cartContent: content);
}

class AddToCartFailure extends AddToCartState {
  final String message;

  const AddToCartFailure({
    required this.message,
    required List<String> content,
  }) : super(cartContent: content);
}

class UserNotLogged extends AddToCartState {
  UserNotLogged() : super(cartContent: List.empty());
}
