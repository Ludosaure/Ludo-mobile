part of 'get_games_cubit.dart';

@immutable
abstract class GetGamesState {
  final List<Game> games;
  const GetGamesState({
    this.games = const [],
  });
}

class GetGamesInitial extends GetGamesState {
  const GetGamesInitial() : super();
}

class GetGamesLoading extends GetGamesState {
  const GetGamesLoading() : super();
}

class GetGamesSuccess extends GetGamesState {
  const GetGamesSuccess({required List<Game> games}) : super(games: games);
}

class GetGamesError extends GetGamesState {
  final String message;
  const GetGamesError({required this.message}) : super();
}

