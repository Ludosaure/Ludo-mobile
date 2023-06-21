import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/data/repositories/game_repository.dart';
import 'package:meta/meta.dart';

part 'delete_game_state.dart';

@injectable
class DeleteGameCubit extends Cubit<DeleteGameState> {
  final GameRepository _gameRepository;
  
  DeleteGameCubit(this._gameRepository) : super(DeleteGameInitial());
  
  Future<void> deleteGame(String gameId) async {
    emit(DeleteGameLoading());
    try {
      // await _gameRepository.deleteGame(gameId);
      emit(DeleteGameSuccess());
    } catch (error) {
      if(error is ForbiddenException) {
        emit(UserNotAdmin());
        return;
      }
      
      emit(DeleteGameError(message: error.toString()));
    }
  }
}
