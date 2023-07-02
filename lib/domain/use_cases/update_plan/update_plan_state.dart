part of 'update_plan_bloc.dart';

@immutable
abstract class UpdatePlanState {}

class UpdatePlanInitial extends UpdatePlanState {
  final String? id;
  final String name;
  final bool isActive;
  final FormStatus status;


  UpdatePlanInitial({
    this.id,
    this.name = '',
    this.isActive = true,
    this.status = const FormNotSent(),
  });

  UpdatePlanInitial copyWith({
    String? id,
    String? name,
    bool? isActive,
    FormStatus? status = const FormNotSent(),
  }) {
    return UpdatePlanInitial(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'UpdatePlanInitial('
        'id: $id, '
        'name: $name, '
        'isActive: $isActive, '
        'status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UpdatePlanInitial &&
      other.id == id &&
      other.name == name &&
      other.isActive == isActive &&
      other.status == status;
  }

  @override
  int get hashCode {
    return
      id.hashCode ^
      name.hashCode ^
      isActive.hashCode ^
      status.hashCode;
  }
}

class UserMustLog extends UpdatePlanInitial {}
