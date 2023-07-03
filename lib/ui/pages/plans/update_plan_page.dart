import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/domain/models/plan.dart';
import 'package:ludo_mobile/domain/use_cases/list_reduction_plan/list_reduction_plan_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/update_plan/update_plan_bloc.dart';
import 'package:ludo_mobile/ui/components/form_field_decoration.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class UpdatePlanPage extends StatefulWidget {
  final Plan plan;

  const UpdatePlanPage({
    Key? key,
    required this.plan,
  }) : super(key: key);

  @override
  State<UpdatePlanPage> createState() => _UpdatePlanPageState();
}

class _UpdatePlanPageState extends State<UpdatePlanPage> {
  final _formKey = GlobalKey<FormState>();

  Plan get plan => widget.plan;

  @override
  void initState() {
    context.read<UpdatePlanBloc>().add(IdChangedEvent(plan.id));
    super.initState();
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
        title: const Text('update-plan-label').tr(),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildForm(context),
            _buildSubmitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            initialValue: plan.name,
            decoration: FormFieldDecoration.textField('plan-name-field'.tr()),
            onChanged: (value) {
              context.read<UpdatePlanBloc>().add(NameChangedEvent(value));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            title: Text(
              'active-reduction-label'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Switch(
              activeColor: Theme.of(context).colorScheme.primary,
              value: plan.isActive,
              onChanged: (value) {
                setState(() {
                  plan.isActive = value;
                });
                context.read<UpdatePlanBloc>().add(
                      IsActiveChangedEvent(value),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext parentContext) {
    return BlocConsumer<UpdatePlanBloc, UpdatePlanInitial>(
      listener: (context, state) {
        if (state.status is FormSubmissionSuccessful) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'plan-updated-successfully',
              ).tr(),
            ),
          );
          parentContext.read<ListReductionPlanCubit>().listReductionPlan();
          context.go(Routes.planList.path);
        } else if (state.status is FormSubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                (state.status as FormSubmissionFailed).message,
              ),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        } else if (state is UserMustLog) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'user-must-log'.tr(),
              ),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status is FormSubmitting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is UserMustLog) {
          context.go(Routes.login.path);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context
                    .read<UpdatePlanBloc>()
                    .add(const UpdatePlanSubmitEvent());
              }
            },
            child: const Text('update-label').tr(),
          ),
        );
      },
    );
  }
}
