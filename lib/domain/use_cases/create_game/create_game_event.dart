part of 'create_game_bloc.dart';

@immutable
abstract class CreateGameEvent {
  const CreateGameEvent();
}

class CreateGameSubmitEvent extends CreateGameEvent {
  const CreateGameSubmitEvent();
}

class GameNameChangedEvent extends CreateGameEvent {
  final String name;

  const GameNameChangedEvent(this.name);
}

class GameDescriptionChangedEvent extends CreateGameEvent {
  final String description;

  const GameDescriptionChangedEvent(this.description);
}

class GameWeeklyAmountChangedEvent extends CreateGameEvent {
  final double weeklyAmount;

  const GameWeeklyAmountChangedEvent(this.weeklyAmount);
}

class GameCategoryChangedEvent extends CreateGameEvent {
  final String categoryId;

  const GameCategoryChangedEvent(this.categoryId);
}

class GameMinAgeChangedEvent extends CreateGameEvent {
  final int minAge;

  const GameMinAgeChangedEvent(this.minAge);
}

class GameAverageDurationChangedEvent extends CreateGameEvent {
  final int averageDuration;

  const GameAverageDurationChangedEvent(this.averageDuration);
}

class GameMinPlayersChangedEvent extends CreateGameEvent {
  final int minPlayers;

  const GameMinPlayersChangedEvent(this.minPlayers);
}

class GameMaxPlayersChangedEvent extends CreateGameEvent {
  final int maxPlayers;

  const GameMaxPlayersChangedEvent(this.maxPlayers);
}

class GamePictureChangedEvent extends CreateGameEvent {
  final dynamic image;

  const GamePictureChangedEvent(this.image);
}






