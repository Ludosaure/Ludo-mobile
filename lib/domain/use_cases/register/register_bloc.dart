import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/authentication/register/register_request.dart';
import 'package:ludo_mobile/data/repositories/authentication_repository.dart';
import 'package:meta/meta.dart';

import '../../../core/form_status.dart';

part 'register_event.dart';
part 'register_state.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterInitial> {
  final AuthenticationRepository _registerRepository;

  RegisterBloc(this._registerRepository) : super(RegisterInitial()) {
    on<FirstnameChangedEvent>(onFirstnameChanged);
    on<LastnameChangedEvent>(onLastnameChanged);
    on<PasswordChangedEvent>(onPasswordChanged);
    on<PasswordConfirmationChangedEvent>(onPasswordConfirmationChanged);
    on<EmailChangedEvent>(onEmailChanged);
    on<PhoneChangedEvent>(onPhoneChanged);
    on<RegisterSubmitEvent>(onSubmitForm);
  }
  
  void onFirstnameChanged(event, Emitter emit) async {
    emit(state.copyWith(firstname: event.firstname));
  }
  
  void onLastnameChanged(event, Emitter emit) async {
    emit(state.copyWith(lastname: event.lastname));
  }
  
  void onEmailChanged(event, Emitter emit) async {
    emit(state.copyWith(email: event.email));
  }
  
  void onPasswordChanged(event, Emitter emit) async {
    emit(state.copyWith(password: event.password));
  }
  
  void onPasswordConfirmationChanged(event, Emitter emit) async {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }
  
  void onPhoneChanged(event, Emitter emit) async {
    emit(state.copyWith(phone: event.phone));
  }

  void onSubmitForm(event, Emitter emit) async {
    String formattedPhoneNumber = state.phone;

    if(state.phone.startsWith('0')) {
      formattedPhoneNumber = state.phone.replaceFirst('0', '+33');
    }

    final registerRequest = RegisterRequest(
      firstname: state.firstname,
      lastname: state.lastname,
      email: state.email,
      password: state.password,
      confirmPassword: state.confirmPassword,
      phone: formattedPhoneNumber,
    );

    try {
      await _registerRepository.register(registerRequest);
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
}