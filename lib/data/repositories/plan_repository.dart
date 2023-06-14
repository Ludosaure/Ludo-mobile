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
}