import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/data/providers/authentication/login/login_request.dart';
import 'package:ludo_mobile/data/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';

part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationRepository _authenticationRepository;

  LoginBloc(this._authenticationRepository) : super(LoginState()) {
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
    try {
      await _authenticationRepository.login(req);
    } catch (exception) {
        emit(state.copyWith(
          status: FormSubmissionFailed(message: exception.toString()),
        ));
        return;
    }

    emit(state.copyWith(
      status: const FormSubmissionSuccessful(),
    ));
  }

  void onLogout(event, Emitter emit) async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('token');
    });

    emit(
      state.copyWith(
        email: '',
        password: '',
        status: const FormNotSent(),
      ),
    );
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
