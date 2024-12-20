import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/data/providers/user/update_user_request.dart';
import 'package:ludo_mobile/data/repositories/media_repository.dart';
import 'package:ludo_mobile/data/repositories/user_repository.dart';
import 'package:ludo_mobile/domain/models/user.dart' as db_user;
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:ludo_mobile/firebase/service/firebase_auth_service.dart';
import 'package:ludo_mobile/firebase/service/firebase_database_service.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';
import 'package:meta/meta.dart';

part 'update_user_event.dart';

part 'update_user_state.dart';

@injectable
class UpdateUserBloc extends Bloc<UpdateUserEvent, UpdateUserInitial> {
  final SessionCubit _sessionCubit;
  final UserRepository _userRepository;
  final MediaRepository _mediaRepository;
  final FirebaseAuthService _firebaseAuthService;

  UpdateUserBloc(
    this._sessionCubit,
    this._userRepository,
    this._mediaRepository,
    this._firebaseAuthService,
  ) : super(UpdateUserInitial()) {
    on<UpdateUserSubmitEvent>(onSubmitForm);
    on<UserPasswordChangedEvent>(onPasswordChanged);
    on<UserConfirmPasswordChangedEvent>(onConfirmPasswordChanged);
    on<UserPhoneNumberChangedEvent>(onPhoneNumberChanged);
    on<UserPseudoChangedEvent>(onPseudoChanged);
    on<UserHasEnabledMailNotificationsChangedEvent>(
        onHasEnabledMailNotificationsChanged);
    on<UserPictureChangedEvent>(onPictureChanged);
    on<UserIdChangedEvent>(onUserChanged);
  }

  void onSubmitForm(event, Emitter emit) async {
    String? imageId;

    emit(
      state.copyWith(
        status: const FormSubmitting(),
      ),
    );

    if (state.image != null) {
      try {
        imageId = await _uploadImage(state.image!);
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

    var formattedPhoneNumber = state.phoneNumber;
    if(state.phoneNumber != null) {
      if(state.phoneNumber!.startsWith('0')) {
        formattedPhoneNumber = state.phoneNumber!.replaceFirst('0', '+33');
      }
    }
    UpdateUserRequest userRequest = UpdateUserRequest(
      userId: state.userId!,
      password: state.password,
      confirmPassword: state.confirmPassword,
      phoneNumber: formattedPhoneNumber,
      pseudo: state.pseudo,
      hasEnabledMailNotifications: state.hasEnabledMailNotifications,
      profilePictureId: imageId,
    );

    db_user.User user;

    try {
      if (userRequest.password != null) {
        await _firebaseAuthService.updateUserPassword(userRequest.password!);
      }
      user = await _userRepository.updateUser(userRequest);
      if (user.profilePicturePath != null) {
        FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
            .updateUserProfilePicture(user.profilePicturePath!);
      }
    } catch (error) {
      if (error is UserNotLoggedInException || error is NotAllowedException) {
        _sessionCubit.logout();
        emit(UserMustLog);
        return;
      }

      if (error is FirebaseAuthException) {
        emit(
          state.copyWith(
            status: FormSubmissionFailed(
                message: 'errors.firebase-update-password-error'.tr()),
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: FormSubmissionFailed(message: error.toString()),
          ),
        );
      }
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
    emit(state.copyWith(
        hasEnabledMailNotifications: event.hasEnabledMailNotifications));
  }

  void onPictureChanged(UserPictureChangedEvent event, Emitter emit) async {
    emit(state.copyWith(image: event.picture));
  }

  void onUserChanged(event, Emitter emit) async {
    emit(state.copyWith(userId: event.userId));
  }

  Future<String> _uploadImage(dynamic image) async {
    return await _mediaRepository.uploadPicture(image);
  }

  @override
  Future<void> close() {
    _sessionCubit.close();
    return super.close();
  }
}
