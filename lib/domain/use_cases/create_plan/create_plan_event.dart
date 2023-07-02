part of 'create_plan_bloc.dart';

@immutable
abstract class CreatePlanEvent {
  const CreatePlanEvent();
}

class CreatePlanSubmitEvent extends CreatePlanEvent {
  const CreatePlanSubmitEvent();
}

class NameChangedEvent extends CreatePlanEvent {
  final String name;

  const NameChangedEvent(this.name);
}

class ReductionChangedEvent extends CreatePlanEvent {
  final int reduction;

  const ReductionChangedEvent(this.reduction);
}

class NbWeeksChangedEvent extends CreatePlanEvent {
  final int nbWeeks;

  const NbWeeksChangedEvent(this.nbWeeks);
}






