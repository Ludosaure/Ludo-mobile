import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/plan_provider.dart';
import 'package:ludo_mobile/domain/models/plan.dart';

@injectable
class PlanRepository {
  final PlanProvider _planProvider;

  PlanRepository(this._planProvider);

  Future<List<Plan>> getPlans() async {
    return await _planProvider.listPlans();
  }

  Future<void> createPlan(String name, int reduction, int nbWeeks) {
    return _planProvider.createPlan(name, reduction, nbWeeks);
  }

  Future<void> updatePlan(String id, String? name, bool? isActive) {
    return _planProvider.updatePlan(id, name, isActive);
  }
}