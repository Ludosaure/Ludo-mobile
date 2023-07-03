part of 'update_plan_bloc.dart';

@immutable
abstract class UpdatePlanEvent {
  const UpdatePlanEvent();
}

class UpdatePlanSubmitEvent extends UpdatePlanEvent {
  const UpdatePlanSubmitEvent();
}

class IdChangedEvent extends UpdatePlanEvent {
  final String id;

  const IdChangedEvent(this.id);
}

class NameChangedEvent extends UpdatePlanEvent {
  final String name;

  const NameChangedEvent(this.name);
}

class IsActiveChangedEvent extends UpdatePlanEvent {
  final bool isActive;

  const IsActiveChangedEvent(this.isActive);
}






