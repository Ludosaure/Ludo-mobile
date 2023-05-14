import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'session_state.dart';

@injectable
class SessionCubit extends Cubit<SessionState> with ChangeNotifier {
  SessionCubit() : super(SessionInitial()) {
    checkSession();
  }

  void checkSession() async {
    print('Checking session...');
    User? user = await LocalStorageHelper.getUserFromLocalStorage();

    if (user == null) {
      print('User not logged');
      emit(
        UserNotLogged(),
      );
    } else {
      print('User logged');

      emit(
        UserLoggedIn(user: user),
      );
    }

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
