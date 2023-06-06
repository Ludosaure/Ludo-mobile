import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

part 'add_to_cart_event.dart';
part 'add_to_cart_state.dart';

@injectable
class AddToCartBloc extends Bloc<AddToCartEvent, AddToCartState> {
  AddToCartBloc() : super(AddToCartInitial()) {
    on<AddToCartSubmitEvent>(onAddToCart);
    on<RemoveFromCartSubmitEvent>(onRemoveFromCart);
  }

  void isGameInCart(String gameId) {

  }

  void onAddToCart(event, Emitter emit) async {
    print('loading');
    print(event);
    emit(AddToCartLoading());
    await Future.delayed(const Duration(seconds: 2), () {
      print('success');
      emit(AddToCartSuccess(content: state.cartContent + [event.gameId]));
    });
  }

  void onRemoveFromCart(event, Emitter emit) async {
    print('loading');
    emit(AddToCartLoading());
    await Future.delayed(const Duration(seconds: 2), () {
      print('success');
      emit(RemoveFromCartSuccess(content: state.cartContent + [event.gameId]));
    });
  }

  // ?
  void onChangeDate(event, Emitter emit) async {
    print('loading');
    emit(AddToCartLoading());
    await Future.delayed(const Duration(seconds: 2), () {
      print('success');
      emit(RemoveFromCartSuccess(content: state.cartContent + [event.gameId]));
    });
  }
}
