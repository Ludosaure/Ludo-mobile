part of 'create_plan_bloc.dart';

@immutable
abstract class CreatePlanState {}

class CreatePlanInitial extends CreatePlanState {
  final String name;
  final int reduction;
  final int nbWeeks;
  final FormStatus status;


  CreatePlanInitial({
    this.name = '',
    this.reduction = 0,
    this.nbWeeks = 0,
    this.status = const FormNotSent(),
  });

  CreatePlanInitial copyWith({
    String? name,
    int? reduction,
    int? nbWeeks,
    FormStatus? status = const FormNotSent(),
  }) {
    return CreatePlanInitial(
      name: name ?? this.name,
      reduction: reduction ?? this.reduction,
      nbWeeks: nbWeeks ?? this.nbWeeks,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'CreatePlanInitial('
        'name: $name, '
        'reduction: $reduction, '
        'nbWeeks: $nbWeeks, '
        'status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CreatePlanInitial &&
      other.name == name &&
      other.reduction == reduction &&
      other.nbWeeks == nbWeeks &&
      other.status == status;
  }

  @override
  int get hashCode {
    return
      name.hashCode ^
      reduction.hashCode ^
      nbWeeks.hashCode ^
      status.hashCode;
  }
}

class UserMustLog extends CreatePlanInitial {}
