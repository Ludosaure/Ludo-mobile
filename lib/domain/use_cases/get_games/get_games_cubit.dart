import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/repositories/game_repository.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:meta/meta.dart';

part 'get_games_state.dart';

@injectable
class GetGamesCubit extends Cubit<GetGamesState> {
  final GameRepository _getGamesRepository;

  GetGamesCubit(this._getGamesRepository) : super(const GetGamesInitial());

  void getGames() async {
    emit(const GetGamesLoading());
    try {
      final games = await _getGamesRepository.getGames();
      emit(GetGamesSuccess(games: games));
    } catch (e) {
      emit(
        GetGamesError(message: e.toString()),
      );
    }
  }
}
