import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/data/providers/game/new_game_request.dart';
import 'package:ludo_mobile/data/repositories/game_repository.dart';
import 'package:meta/meta.dart';

part 'create_game_event.dart';

part 'create_game_state.dart';

@injectable
class CreateGameBloc extends Bloc<CreateGameEvent, CreateGameInitial> {
  final GameRepository _createGameRepository;

  CreateGameBloc(this._createGameRepository) : super(CreateGameInitial()) {
    on<CreateGameSubmitEvent>(onSubmitForm);
    on<GameNameChangedEvent>(onNameChanged);
    on<GameDescriptionChangedEvent>(onDescriptionChanged);
    on<GameWeeklyAmountChangedEvent>(onWeeklyAmountChanged);
    on<GameCategoryChangedEvent>(onCategoryChanged);
    on<GameMinAgeChangedEvent>(onMinAgeChanged);
    on<GameAverageDurationChangedEvent>(onAverageDurationChanged);
    on<GameMinPlayersChangedEvent>(onMinPlayersChanged);
    on<GameMaxPlayersChangedEvent>(onMaxPlayersChanged);
  }

  void onSubmitForm(event, Emitter emit) async {
    final newGameRequest = NewGameRequest(
      name: state.name,
      description: state.description,
      weeklyAmount: state.weeklyAmount,
      categoryId: state.categoryId,
      minAge: state.minAge,
      averageDuration: state.averageDuration,
      minPlayers: state.minPlayers,
      maxPlayers: state.maxPlayers,
    );
    String gameId = '';
    try {
      emit(
        state.copyWith(
          status: const FormSubmitting(),
        ),
      );
      gameId = await _createGameRepository.createGame(newGameRequest);
    } catch (error) {
      emit(
        state.copyWith(
          status: FormSubmissionFailed(message: error.toString()),
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        id: gameId,
        status: const FormSubmissionSuccessful(),
      ),
    );
  }

  void onNameChanged(event, Emitter emit) async {
    emit(state.copyWith(name: event.name));
  }

  void onDescriptionChanged(event, Emitter emit) async {
    emit(state.copyWith(description: event.description));
  }

  void onWeeklyAmountChanged(event, Emitter emit) async {
    emit(state.copyWith(weeklyAmount: event.weeklyAmount));
  }

  void onCategoryChanged(event, Emitter emit) async {
    emit(state.copyWith(categoryId: event.categoryId));
  }

  void onMinAgeChanged(event, Emitter emit) async {
    emit(state.copyWith(minAge: event.minAge));
  }

  void onAverageDurationChanged(event, Emitter emit) async {
    emit(state.copyWith(averageDuration: event.averageDuration));
  }

  void onMinPlayersChanged(event, Emitter emit) async {
    emit(state.copyWith(minPlayers: event.minPlayers));
  }

  void onMaxPlayersChanged(event, Emitter emit) async {
    emit(state.copyWith(maxPlayers: event.maxPlayers));
  }
}
