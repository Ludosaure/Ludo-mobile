import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/repositories/favorite/favorite_games_repository.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:meta/meta.dart';

part 'handle_favorite_game_state.dart';

@injectable
class HandleFavoriteGameCubit extends Cubit<HandleFavoriteGameState> {
  final SessionCubit _sessionCubit;
  final FavoriteGamesRepository _favoriteRepository;

  HandleFavoriteGameCubit(
    this._sessionCubit,
    this._favoriteRepository,
  ) : super(HandleFavoriteGameInitial());

  void addToFavorite(String gameId) async {
    emit(OperationInProgress());
    try {
      if (_sessionCubit.state is! UserLoggedIn) {
        emit(UserNotLogged());
        return;
      }

      await _favoriteRepository.addToFavorite(
        gameId,
      );
      emit(OperationSuccess());
    } catch (exception) {
      emit(
        OperationFailure(message: exception.toString()),
      );
    }
  }

  void removeFromFavorite(String gameId) async {
    emit(OperationInProgress());
    try {
      if (_sessionCubit.state is! UserLoggedIn) {
        emit(UserNotLogged());
        return;
      }

      await _favoriteRepository.removeFromFavorite(
        gameId,
      );
      emit(OperationSuccess());
    } catch (exception) {
      emit(
        OperationFailure(message: exception.toString()),
      );
    }
  }
}
