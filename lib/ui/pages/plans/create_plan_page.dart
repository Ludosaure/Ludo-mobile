import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/domain/use_cases/create_plan/create_plan_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/list_reduction_plan/list_reduction_plan_cubit.dart';
import 'package:ludo_mobile/ui/components/form_field_decoration.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class CreatePlanPage extends StatefulWidget {
  const CreatePlanPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CreatePlanPage> createState() => _CreatePlanPageState();
}

class _CreatePlanPageState extends State<CreatePlanPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.pop();
          },
        ),
        title: const Text('add-plan-label').tr(),
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
            decoration: FormFieldDecoration.textField('plan-name-field'.tr()),
            validator: RequiredValidator(
              errorText: "form.field-required-msg".tr(),
            ),
            onChanged: (value) {
              context.read<CreatePlanBloc>().add(NameChangedEvent(value));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: FormFieldDecoration.textField(
              'reduction-field'.tr(),
              suffixText: 'percent-symbol'.tr(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "form.field-required-msg".tr();
              }

              final intValue = int.tryParse(value);
              if (intValue == null || intValue < 0 || intValue > 100) {
                return "percentage-error".tr();
              }

              return null;
            },
            onChanged: (value) {
              final intValue = int.tryParse(value);
              if (intValue != null) {
                context.read<CreatePlanBloc>().add(
                  ReductionChangedEvent(intValue),
                );
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: FormFieldDecoration.textField(
              'nb-weeks-field'.tr(),
            ),
            keyboardType: TextInputType.number,
            validator: RequiredValidator(
              errorText: "form.field-required-msg".tr(),
            ),
            onChanged: (value) {
              context.read<CreatePlanBloc>().add(
                    NbWeeksChangedEvent(
                      int.parse(value),
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocConsumer<CreatePlanBloc, CreatePlanInitial>(
      listener: (context, state) {
        if (state.status is FormSubmissionSuccessful) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'plan-created-successfully',
              ).tr(),
            ),
          );
          context.read<ListReductionPlanCubit>().listReductionPlan();
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
                    .read<CreatePlanBloc>()
                    .add(const CreatePlanSubmitEvent());
              }
            },
            child: const Text('add-label').tr(),
          ),
        );
      },
    );
  }
}
