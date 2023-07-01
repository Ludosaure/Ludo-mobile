import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/data/repositories/unavailabilities_repository.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';

part 'game_unavailabilities_state.dart';

@injectable
class GameUnavailabilitiesCubit extends Cubit<GameUnavailabilitiesState> {
  final SessionCubit _sessionCubit;
  final UnavailabilitiesRepository _gameUnavailabilitiesRepository;

  GameUnavailabilitiesCubit(
    this._sessionCubit,
    this._gameUnavailabilitiesRepository,
  ) : super(GameUnavailabilitiesInitial());

  void createUnavailability(String gameId, DateTime date) async {
    emit(GameUnavailabilitiesLoading());
    try {
      if (_sessionCubit.state is! UserLoggedIn) {
        emit(const UserNotLogged());
        return;
      }

      await _gameUnavailabilitiesRepository.createUnavailability(
          gameId, date);

      emit(GameUnavailabilitiesSuccess(date: date));
    } catch (exception) {
      if (exception is UserNotLoggedInException) {
        _sessionCubit.logout();
        emit(const UserNotLogged());
        return;
      }

      emit(
        GameUnavailabilitiesError(message: exception.toString()),
      );
    }
  }

  void deleteUnavailability(String gameId, DateTime date) async {
    emit(GameUnavailabilitiesLoading());
    try {
      if (_sessionCubit.state is! UserLoggedIn) {
        emit(const UserNotLogged());
        return;
      }

      await _gameUnavailabilitiesRepository.deleteUnavailability(
          gameId, date);

      emit(GameUnavailabilitiesSuccess(date: date, isCreation: false));
    } catch (exception) {
      if (exception is UserNotLoggedInException) {
        _sessionCubit.logout();
        emit(const UserNotLogged());
        return;
      }

      emit(
        GameUnavailabilitiesError(message: exception.toString()),
      );
    }
  }

  @override
  Future<void> close() {
    _sessionCubit.close();
    return super.close();
  }
}
