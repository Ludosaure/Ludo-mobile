part of 'update_game_bloc.dart';

@immutable
abstract class UpdateGameEvent {
  const UpdateGameEvent();
}

class UpdateGameSubmitEvent extends UpdateGameEvent {
  const UpdateGameSubmitEvent();
}

class GameNameChangedEvent extends UpdateGameEvent {
  final String name;

  const GameNameChangedEvent(this.name);
}

class GameDescriptionChangedEvent extends UpdateGameEvent {
  final String description;

  const GameDescriptionChangedEvent(this.description);
}

class GameWeeklyAmountChangedEvent extends UpdateGameEvent {
  final double weeklyAmount;

  const GameWeeklyAmountChangedEvent(this.weeklyAmount);
}

class GameCategoryChangedEvent extends UpdateGameEvent {
  final String categoryId;

  const GameCategoryChangedEvent(this.categoryId);
}

class GameMinAgeChangedEvent extends UpdateGameEvent {
  final int minAge;

  const GameMinAgeChangedEvent(this.minAge);
}

class GameAverageDurationChangedEvent extends UpdateGameEvent {
  final int averageDuration;

  const GameAverageDurationChangedEvent(this.averageDuration);
}

class GameMinPlayersChangedEvent extends UpdateGameEvent {
  final int minPlayers;

  const GameMinPlayersChangedEvent(this.minPlayers);
}

class GameMaxPlayersChangedEvent extends UpdateGameEvent {
  final int maxPlayers;

  const GameMaxPlayersChangedEvent(this.maxPlayers);
}

class GamePictureChangedEvent extends UpdateGameEvent {
  final dynamic picture;

  const GamePictureChangedEvent(this.picture);
}

class GameIdChangedEvent extends UpdateGameEvent {
  final String id;

  const GameIdChangedEvent(this.id);
}
