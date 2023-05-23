import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/repositories/favorite/favorite_game.dart';
import 'package:ludo_mobile/data/repositories/favorite/favorite_games_repository.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:meta/meta.dart';

part 'favorite_games_state.dart';

@singleton
class FavoriteGamesCubit extends Cubit<FavoriteGamesState> {
  final SessionCubit _sessionCubit;
  final FavoriteGamesRepository _favoriteRepository;

  FavoriteGamesCubit(
    this._sessionCubit,
    this._favoriteRepository,
  ) : super(const GetFavoriteGamesInitial());

  Future<void> getFavorites() async {
    emit(const GetFavoriteGamesLoading());
    try {
      if (_sessionCubit.state is! UserLoggedIn) {
        emit(const GetFavoriteGamesUserNotLogged());
        return;
      }

      final favorites = await _favoriteRepository
          .getFavorites((_sessionCubit.state as UserLoggedIn).user.id);
      emit(GetFavoriteGamesSuccess(favorites: favorites));
    } catch (exception) {
      emit(
        GetFavoriteGamesError(message: exception.toString()),
      );
    }
  }

  bool isFavorite(Game game) {
    if (state is GetFavoriteGamesSuccess) {
      final favorites = (state as GetFavoriteGamesSuccess).favorites;
      return favorites.any((element) => element.gameId == game.id);
    }
    return false;
  }

  void addToFavorite(Game game) async {
    emit(OperationInProgress());
    try {
      if (_sessionCubit.state is! UserLoggedIn) {
        emit(const UserNotLogged());
        return;
      }

      await _favoriteRepository.addToFavorite(
        game.id,
      );

      emit(OperationSuccess());
    } catch (exception) {
      emit(
        OperationFailure(message: exception.toString()),
      );
    }
  }

  void removeFromFavorite(Game game) async {
    emit(OperationInProgress());
    try {
      if (_sessionCubit.state is! UserLoggedIn) {
        emit(const UserNotLogged());
        return;
      }

      await _favoriteRepository.removeFromFavorite(
        game.id,
      );
      emit(OperationSuccess());
    } catch (exception) {
      emit(
        OperationFailure(message: exception.toString()),
      );
    }
  }

  dispose() {
    _sessionCubit.close();
    close();
  }
}
