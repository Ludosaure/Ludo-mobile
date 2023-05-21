import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/repositories/favorite_games_repository.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:meta/meta.dart';

part 'get_favorite_games_state.dart';

@injectable
class GetFavoriteGamesCubit extends Cubit<GetFavoriteGamesState> {
  final SessionCubit _sessionCubit;
  final FavoriteGamesRepository _favoriteRepository;

  GetFavoriteGamesCubit(
    this._sessionCubit,
    this._favoriteRepository,
  ) : super(const GetFavoriteGamesInitial());

  void getFavorites() async {
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
}
