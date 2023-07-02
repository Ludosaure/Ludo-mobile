import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/plan.dart';
import 'package:ludo_mobile/domain/use_cases/list_reduction_plan/list_reduction_plan_cubit.dart';

class PlanListPage extends StatefulWidget {
  const PlanListPage({super.key});

  @override
  State<PlanListPage> createState() => _PlanListPageState();
}

class _PlanListPageState extends State<PlanListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ListReductionPlanCubit>().listReductionPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text('list-plans-title').tr(),
      ),
      body: _buildPlans(context),
    );
  }

  Widget _buildPlans(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: BlocConsumer<ListReductionPlanCubit, ListReductionPlanState>(
        listener: (context, state) {
          if (state is UserMustLogError) {
            context.go('/login');
          }
        },
        builder: (context, state) {
          if (state is ListReductionPlanLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ListReductionPlanError) {
            return Center(
              child: const Text("errors.error-detail").tr(
                namedArgs: {'error': state.message},
              ),
            );
          }

          if (state is ListReductionPlanSuccess) {
            return _buildPlansList(context, state.plans);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildPlansList(BuildContext context, List<Plan> plans) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ListReductionPlanCubit>().listReductionPlan();
      },
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: ListTile(
              title: Text(plan.name),
              subtitle: Text(
                "booking-nb-weeks-label".plural(plan.nbWeeks),
              ).tr(namedArgs: {
                'nbWeeks': plan.nbWeeks.toString(),
              }),
              trailing: Text('${plan.reduction}%'),
            ),
          );
        },
      ),
    );
  }
}
