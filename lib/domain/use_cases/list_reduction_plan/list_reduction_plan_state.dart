part of 'list_reduction_plan_cubit.dart';

@immutable
abstract class ListReductionPlanState {
  final List<Plan> plans;
  const ListReductionPlanState({
    this.plans = const [],
  });
}

class ListReductionPlanInitial extends ListReductionPlanState {
  const ListReductionPlanInitial() : super();
}

class ListReductionPlanLoading extends ListReductionPlanState {
  const ListReductionPlanLoading() : super();
}

class ListReductionPlanSuccess extends ListReductionPlanState {
  const ListReductionPlanSuccess({required List<Plan> plans})
      : super(plans: plans);
}

class ListReductionPlanError extends ListReductionPlanState {
  final String message;
  const ListReductionPlanError({required this.message}) : super();
}

class UserMustLogError extends ListReductionPlanInitial {
  final String message;
  const UserMustLogError({required this.message}) : super();
}
