import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/cart/cart_cubit.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';

part 'session_state.dart';

@singleton
class SessionCubit extends Cubit<SessionState> with ChangeNotifier {
  late final CartCubit _cartCubit = locator<CartCubit>();
  SessionCubit() : super(SessionInitial()) {
    checkSession();
  }

  void checkSession() async {
    User? user = await LocalStorageHelper.getUserFromLocalStorage();

    if (user == null) {
      emit(
        UserNotLogged(),
      );
      notifyListeners();
      return;
    }

    emit(
      UserLoggedIn(user: user),
    );
    notifyListeners();
  }

  void userLogged(User user) async {
    emit(
      UserLoggedIn(user: user),
    );
    notifyListeners();
  }

  void logout() async {
    await LocalStorageHelper.removeUserFromLocalStorage();

    emit(
      UserNotLogged(),
    );
    _cartCubit.clearCart();
    notifyListeners();
  }
}
