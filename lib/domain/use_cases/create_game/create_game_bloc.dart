import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/data/providers/game/new_game_request.dart';
import 'package:ludo_mobile/data/repositories/game_repository.dart';
import 'package:ludo_mobile/data/repositories/media_repository.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:meta/meta.dart';

part 'create_game_event.dart';

part 'create_game_state.dart';

@injectable
class CreateGameBloc extends Bloc<CreateGameEvent, CreateGameInitial> {
  final SessionCubit _sessionCubit;
  final GameRepository _createGameRepository;
  final MediaRepository _mediaRepository;

  CreateGameBloc(
    this._sessionCubit,
    this._createGameRepository,
    this._mediaRepository,
  ) : super(CreateGameInitial()) {
    on<CreateGameSubmitEvent>(onSubmitForm);
    on<GameNameChangedEvent>(onNameChanged);
    on<GameDescriptionChangedEvent>(onDescriptionChanged);
    on<GameWeeklyAmountChangedEvent>(onWeeklyAmountChanged);
    on<GameCategoryChangedEvent>(onCategoryChanged);
    on<GameMinAgeChangedEvent>(onMinAgeChanged);
    on<GameAverageDurationChangedEvent>(onAverageDurationChanged);
    on<GameMinPlayersChangedEvent>(onMinPlayersChanged);
    on<GameMaxPlayersChangedEvent>(onMaxPlayersChanged);
    on<GamePictureChangedEvent>(onPictureChanged);
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

    NewGameRequest newGameRequest = NewGameRequest(
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

    try {
      await _createGameRepository.createGame(newGameRequest);
    } catch (error) {
      if(error is UserNotLoggedInException) {
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

    emit(
      state.copyWith(
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

  void onPictureChanged(event, Emitter emit) async {
    emit(state.copyWith(image: event.image));
  }

  Future<String> _uploadImage(File image) async {
    return await _mediaRepository.uploadPicture(image);
  }

  void dispose() {
    _sessionCubit.close();
    super.close();
  }
}
