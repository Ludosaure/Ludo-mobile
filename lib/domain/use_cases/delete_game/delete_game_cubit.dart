import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/data/repositories/game_repository.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:meta/meta.dart';

part 'delete_game_state.dart';

@injectable
class DeleteGameCubit extends Cubit<DeleteGameState> {
  final SessionCubit _sessionCubit;
  final GameRepository _gameRepository;

  DeleteGameCubit(
    this._gameRepository,
    this._sessionCubit,
  ) : super(DeleteGameInitial());

  Future<void> deleteGame(String gameId) async {
    emit(DeleteGameLoading());
    try {
      await _gameRepository.deleteGame(gameId);
      emit(DeleteGameSuccess());
    } catch (error) {
      if (error is ForbiddenException) {
        _sessionCubit.logout();
        emit(UserMustLog());
        return;
      }

      emit(DeleteGameError(message: error.toString()));
    }
  }

  @override
  Future<void> close() {
    _sessionCubit.close();
    return super.close();
  }
}
