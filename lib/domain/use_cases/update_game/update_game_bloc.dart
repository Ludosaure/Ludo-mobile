import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/data/providers/game/update_game_request.dart';
import 'package:ludo_mobile/data/repositories/game_repository.dart';
import 'package:ludo_mobile/data/repositories/media_repository.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/use_cases/get_game/get_game_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/get_games/get_games_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:meta/meta.dart';

part 'update_game_event.dart';

part 'update_game_state.dart';

@injectable
class UpdateGameBloc extends Bloc<UpdateGameEvent, UpdateGameInitial> {
  final SessionCubit _sessionCubit;
  final GetGameCubit _getGameCubit;
  final GetGamesCubit _getGamesCubit;
  final GameRepository _updateGameRepository;
  final MediaRepository _mediaRepository;

  UpdateGameBloc(
    this._sessionCubit,
    this._getGameCubit,
    this._getGamesCubit,
    this._updateGameRepository,
    this._mediaRepository,
  ) : super(UpdateGameInitial()) {
    on<UpdateGameSubmitEvent>(onSubmitForm);
    on<GameNameChangedEvent>(onNameChanged);
    on<GameDescriptionChangedEvent>(onDescriptionChanged);
    on<GameWeeklyAmountChangedEvent>(onWeeklyAmountChanged);
    on<GameCategoryChangedEvent>(onCategoryChanged);
    on<GameMinAgeChangedEvent>(onMinAgeChanged);
    on<GameAverageDurationChangedEvent>(onAverageDurationChanged);
    on<GameMinPlayersChangedEvent>(onMinPlayersChanged);
    on<GameMaxPlayersChangedEvent>(onMaxPlayersChanged);
    on<GamePictureChangedEvent>(onPictureChanged);
    on<GameIdChangedEvent>(onGameChanged);
  }

  void onSubmitForm(event, Emitter emit) async {
    String? imageUrl;

    emit(
      state.copyWith(
        status: const FormSubmitting(),
      ),
    );

    if (state.image != null) {
      try {
        imageUrl = await _uploadImage(state.image!);
      } catch (error) {
        if (error is UserNotLoggedInException) {
          _sessionCubit.logout();
          emit(UserMustLog);
          return;
        }

        emit(
          state.copyWith(
            status: FormSubmissionFailed(message: error.toString()),
          ),
        );

        return;
      }
    }

    //TODO supprimer l'ancienne image s'il y en avait une

    UpdateGameRequest gameRequest = UpdateGameRequest(
      id: state.id,
      name: state.name,
      description: state.description,
      weeklyAmount: state.weeklyAmount,
      categoryId: state.categoryId,
      minAge: state.minAge,
      averageDuration: state.averageDuration,
      minPlayers: state.minPlayers,
      maxPlayers: state.maxPlayers,
      image: imageUrl,
    );

    Game game;

    try {
      game = await _updateGameRepository.updateGame(gameRequest);
    } catch (error) {
      if(error is UserNotLoggedInException || error is NotAllowedException) {
        _sessionCubit.logout();
        emit(UserMustLog);
        return;
      }

      emit(
        state.copyWith(
          status: FormSubmissionFailed(message: error.toString()),
        ),
      );

      return;
    }

    _getGamesCubit.findAndReplace(game);

    emit(
      state.copyWith(
        status: const FormSubmissionSuccessful(),
      ),
    );
  }

  void onNameChanged(event, Emitter emit) async {
    emit(
      state.copyWith(
        name: event.name,
      ),
    );
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

  void onPictureChanged(GamePictureChangedEvent event, Emitter emit) async {
    emit(state.copyWith(image: event.picture));
  }

  Future<String> _uploadImage(File image) async {
    return await _mediaRepository.uploadPicture(image);
  }

  void onGameChanged(event, Emitter emit) async {
    emit(state.copyWith(id: event.id));
  }

  @override
  Future<void> close() {
    _sessionCubit.close();
    _getGameCubit.close();
    _getGamesCubit.close();
    return super.close();
  }
}
