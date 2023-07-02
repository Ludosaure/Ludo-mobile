import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/data/repositories/plan_repository.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:meta/meta.dart';

part 'create_plan_event.dart';
part 'create_plan_state.dart';

@injectable
class CreatePlanBloc extends Bloc<CreatePlanEvent, CreatePlanInitial> {
  final SessionCubit _sessionCubit;
  final PlanRepository _planRepository;

  CreatePlanBloc(
    this._sessionCubit,
    this._planRepository,
  ) : super(CreatePlanInitial()) {
    on<CreatePlanSubmitEvent>(onSubmitForm);
    on<NameChangedEvent>(onNameChanged);
    on<ReductionChangedEvent>(onReductionChanged);
    on<NbWeeksChangedEvent>(onNbWeeksChanged);
  }

  void onSubmitForm(event, Emitter emit) async {
    emit(
      state.copyWith(
        status: const FormSubmitting(),
      ),
    );

    try {
      await _planRepository.createPlan(state.name, state.reduction, state.nbWeeks);
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

  void onNameChanged(NameChangedEvent event, Emitter emit) async {
    emit(state.copyWith(name: event.name));
  }

  void onReductionChanged(ReductionChangedEvent event, Emitter emit) async {
    emit(state.copyWith(reduction: event.reduction));
  }

  void onNbWeeksChanged(NbWeeksChangedEvent event, Emitter emit) async {
    emit(state.copyWith(nbWeeks: event.nbWeeks));
  }

  @override
  Future<void> close() async {
    _sessionCubit.close();
    super.close();
  }
}
