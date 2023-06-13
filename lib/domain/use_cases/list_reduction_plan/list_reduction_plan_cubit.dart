import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/data/repositories/plan_repository.dart';
import 'package:ludo_mobile/domain/models/plan.dart';
import 'package:meta/meta.dart';

part 'list_reduction_plan_state.dart';

@singleton
class ListReductionPlanCubit extends Cubit<ListReductionPlanState> {
  final PlanRepository _listReductionPlanRepository;

  ListReductionPlanCubit(this._listReductionPlanRepository)
      : super(const ListReductionPlanInitial());

  Future<void> listReductionPlan() async {
    emit(const ListReductionPlanLoading());

    try {
      final plans = await _listReductionPlanRepository.getPlans();
      emit(ListReductionPlanSuccess(plans: plans));
    } catch (exception) {
      if (
      exception is UserNotLoggedInException ||
          exception is ForbiddenException
      ) {
        emit(
          UserMustLogError(
            message: exception.toString(),
          ),
        );
        return;
      }

      emit(
        ListReductionPlanError(message: exception.toString()),
      );
    }
  }

  Future<int> getReductionForNbWeeks(int nbWeeks) async {
    if(state is! ListReductionPlanSuccess) {
      return 0;
    }

    return state.plans.where((Plan element) => element.nbWeeks <= nbWeeks)
        .reduce((value, element) => value.reduction > element.reduction ? value : element).reduction;
  }
}