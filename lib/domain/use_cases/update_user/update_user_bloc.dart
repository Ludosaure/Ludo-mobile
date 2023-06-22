import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/data/providers/user/update_user_request.dart';
import 'package:ludo_mobile/data/repositories/media_repository.dart';
import 'package:ludo_mobile/data/repositories/user_repository.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';
import 'package:meta/meta.dart';

part 'update_user_event.dart';

part 'update_user_state.dart';

@injectable
class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserInitial> {
  final SessionCubit _sessionCubit;
  final UserRepository _userRepository;
  final MediaRepository _mediaRepository;

  UpdateUserBloc(
    this._sessionCubit,
    this._userRepository,
    this._mediaRepository,
  ) : super(UpdateUserInitial()) {
    on<UpdateUserSubmitEvent>(onSubmitForm);
    on<UserPasswordChangedEvent>(onPasswordChanged);
    on<UserConfirmPasswordChangedEvent>(onConfirmPasswordChanged);
    on<UserPhoneNumberChangedEvent>(onPhoneNumberChanged);
    on<UserPseudoChangedEvent>(onPseudoChanged);
    on<UserHasEnabledMailNotificationsChangedEvent>(onHasEnabledMailNotificationsChanged);
    on<UserHasEnabledPhoneNotificationsChangedEvent>(onHasEnabledPhoneNotificationsChanged);
    on<UserPictureChangedEvent>(onPictureChanged);
    on<UserIdChangedEvent>(onUserChanged);
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

    UpdateUserRequest userRequest = UpdateUserRequest(
      userId: state.userId,
      password: state.password,
      confirmPassword: state.confirmPassword,
      phoneNumber: state.phoneNumber,
      pseudo: state.pseudo,
      hasEnabledMailNotifications: state.hasEnabledMailNotifications,
      hasEnabledPhoneNotifications: state.hasEnabledPhoneNotifications,
      image: imageUrl,
    );

    User user;

    try {
      user = await _userRepository.updateUser(userRequest);
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

    String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    LocalStorageHelper.saveUserToLocalStorage(user, token!);

    emit(
      state.copyWith(
        status: const FormSubmissionSuccessful(),
      ),
    );
  }

  void onPasswordChanged(event, Emitter emit) async {
    emit(
      state.copyWith(
        password: event.password,
      ),
    );
  }

  void onConfirmPasswordChanged(event, Emitter emit) async {
    emit(
      state.copyWith(
        confirmPassword: event.confirmPassword,
      ),
    );
  }

  void onPhoneNumberChanged(event, Emitter emit) async {
    emit(state.copyWith(phoneNumber: event.phoneNumber));
  }

  void onPseudoChanged(event, Emitter emit) async {
    emit(state.copyWith(pseudo: event.pseudo));
  }

  void onHasEnabledMailNotificationsChanged(event, Emitter emit) async {
    emit(state.copyWith(hasEnabledMailNotifications: event.hasEnabledMailNotifications));
  }

  void onHasEnabledPhoneNotificationsChanged(event, Emitter emit) async {
    emit(state.copyWith(hasEnabledPhoneNotifications: event.hasEnabledPhoneNotifications));
  }

  void onPictureChanged(UserPictureChangedEvent event, Emitter emit) async {
    emit(state.copyWith(image: event.picture));
  }

  void onUserChanged(event, Emitter emit) async {
    emit(state.copyWith(userId: event.userId));
  }

  Future<String> _uploadImage(File image) async {
    return await _mediaRepository.uploadPicture(image);
  }

  @override
  Future<void> close() {
    _sessionCubit.close();
    return super.close();
  }
}
