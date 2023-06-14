import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/repositories/game_repository.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:meta/meta.dart';

part 'get_game_state.dart';

@injectable
class GetGameCubit extends Cubit<GetGameState> {
  final GameRepository _gameRepository;

  GetGameCubit(
    this._gameRepository,
  ) : super(GetGameInitial());

  void getGame(String gameId) async {
    emit(GetGameLoading());
    try {
      final Game game = await _gameRepository.getGame(gameId);
      emit(GetGameSuccess(game: game));
    } catch (exception) {
      emit(
        GetGameError(message: exception.toString()),
      );
    }
  }

  dispose() {
    super.close();
  }
}
