import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';
import 'package:flutter/material.dart';

part 'session_state.dart';

@singleton
class SessionCubit extends Cubit<SessionState> with ChangeNotifier {
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
    notifyListeners();
  }
}
