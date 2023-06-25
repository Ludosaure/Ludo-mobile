import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/data/providers/authentication/login/login_request.dart';
import 'package:ludo_mobile/data/repositories/authentication_repository.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:ludo_mobile/firebase/service/firebase_auth_service.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';

part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;
  final SessionCubit _sessionCubit;
  final FirebaseAuthService _firebaseAuthService;

  LoginBloc(
    this._authenticationRepository,
    this._sessionCubit,
    this._firebaseAuthService,
  ) : super(LoginState()) {
    on<LoginSubmitEvent>(onSubmitForm);
    on<EmailChangedEvent>(onEmailChanged);
    on<PasswordChangedEvent>(onPasswordChanged);
    on<LogoutEvent>(onLogout);
    on<ResendConfirmAccountEmailEvent>(onResendConfirmAccountEmail);
  }

  void onEmailChanged(event, Emitter emit) async {
    emit(state.copyWith(email: event.email));
  }

  void onPasswordChanged(event, Emitter emit) async {
    emit(state.copyWith(password: event.password));
  }

  void onSubmitForm(event, Emitter emit) async {
    final req = LoginRequest(email: state.email, password: state.password);
    User user;

    try {
      user = await _authenticationRepository.login(req);
      await _firebaseAuthService.login(state.email, state.password);
    } catch (exception) {
      emit(state.copyWith(
        status: FormSubmissionFailed(message: exception.toString()),
      ));
      return;
    }

    emit(
      state.copyWith(
        status: const FormSubmissionSuccessful(),
        loggedUser: user,
      ),
    );

    _sessionCubit.userLogged(user);
  }

  void onLogout(event, Emitter emit) async {
    LocalStorageHelper.removeUserFromLocalStorage();

    emit(
      state.copyWith(
        email: '',
        password: '',
        status: const FormNotSent(),
        loggedUser: null,
      ),
    );
    _sessionCubit.logout();
  }

  void onResendConfirmAccountEmail(event, Emitter emit) async {
    try {
      await _authenticationRepository.resendConfirmAccountEmail(event.email);
    } catch (exception) {
      emit(state.copyWith(
        status: FormSubmissionFailed(message: exception.toString()),
      ));
      return;
    }
  }
}
