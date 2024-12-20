import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/repositories/game_repository.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:meta/meta.dart';

part 'get_game_state.dart';

@injectable
class GetGameCubit extends Cubit<GetGameState> {
  final SessionCubit _sessionCubit;
  final GameRepository _gameRepository;

  GetGameCubit(
      this._sessionCubit,
    this._gameRepository,
  ) : super(GetGameInitial());

  void getGame(String gameId) async {
    emit(GetGameLoading());
    User? user;
    if(_sessionCubit.state is UserLoggedIn) {
      user = (_sessionCubit.state as UserLoggedIn).user;
    }

    try {
      final Game game = await _gameRepository.getGame(gameId, user);
      emit(GetGameSuccess(game: game));
    } catch (exception) {
      emit(
        GetGameError(message: exception.toString()),
      );
    }
  }

  @override
  Future<void> close() {
    _sessionCubit.close();
    return super.close();
  }
}
