import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/data/repositories/plan_repository.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:meta/meta.dart';

part 'update_plan_event.dart';
part 'update_plan_state.dart';

@injectable
class UpdatePlanBloc extends Bloc<UpdatePlanEvent, UpdatePlanInitial> {
  final SessionCubit _sessionCubit;
  final PlanRepository _planRepository;

  UpdatePlanBloc(
    this._sessionCubit,
    this._planRepository,
  ) : super(UpdatePlanInitial()) {
    on<UpdatePlanSubmitEvent>(onSubmitForm);
    on<IdChangedEvent>(onIdChanged);
    on<NameChangedEvent>(onNameChanged);
    on<IsActiveChangedEvent>(isActiveChanged);
  }

  void onSubmitForm(event, Emitter emit) async {
    emit(
      state.copyWith(
        status: const FormSubmitting(),
      ),
    );

    try {
      await _planRepository.updatePlan(state.id!, state.name, state.isActive);
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

  void onIdChanged(IdChangedEvent event, Emitter emit) async {
    emit(state.copyWith(id: event.id));
  }

  void onNameChanged(NameChangedEvent event, Emitter emit) async {
    emit(state.copyWith(name: event.name));
  }

  void isActiveChanged(IsActiveChangedEvent event, Emitter emit) async {
    emit(state.copyWith(isActive: event.isActive));
  }

  @override
  Future<void> close() async {
    _sessionCubit.close();
    super.close();
  }
}
