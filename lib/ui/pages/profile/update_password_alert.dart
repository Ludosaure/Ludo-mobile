import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/update_user/update_user_bloc.dart';
import 'package:ludo_mobile/ui/components/form_field_decoration.dart';

class UpdatePasswordAlert extends StatefulWidget {
  final User user;

  const UpdatePasswordAlert({Key? key, required this.user}) : super(key: key);

  @override
  State<UpdatePasswordAlert> createState() => _UpdatePasswordAlertState();
}

class _UpdatePasswordAlertState extends State<UpdatePasswordAlert> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  User get user => widget.user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("update-password-title".tr()),
      content: Form(
        key: _formKey,
        child: Column(
          verticalDirection: VerticalDirection.down,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _passwordController,
              validator: MultiValidator([
                RequiredValidator(errorText: 'form.field-required-msg'.tr()),
                MinLengthValidator(8,
                    errorText: 'form.password-min-length-msg'.tr(args: ['8'])),
                //regex for at least one special character
                PatternValidator(
                  r'[!@#$%^&*(),.?":{}|<>]',
                  errorText: 'form.password-special-char-msg'.tr(),
                ),
                PatternValidator(r'(?=.*?[A-Z])',
                    errorText: 'form.password-uppercase-msg'.tr()),
                PatternValidator(r'(?=.*?[a-z])',
                    errorText: 'form.password-lowercase-msg'.tr()),
                PatternValidator(r'(?=.*?[0-9])',
                    errorText: 'form.password-number-msg'.tr()),
              ]),
              onChanged: (value) {
                context
                    .read<UpdateUserBloc>()
                    .add(UserPasswordChangedEvent(value));
              },
              decoration: FormFieldDecoration.passwordField(
                "password-label".tr(),
                _togglePasswordVisibility,
                _hidePassword,
              ),
              obscureText: _hidePassword,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmPasswordController,
              validator: (String? value) {
                if (value != _passwordController.text) {
                  return 'form.passwords-not-matching-msg'.tr();
                }
                return null;
              },
              onChanged: (value) {
                context
                    .read<UpdateUserBloc>()
                    .add(UserConfirmPasswordChangedEvent(value));
              },
              decoration: FormFieldDecoration.passwordField(
                "password-confirm-label".tr(),
                _toggleConfirmPasswordVisibility,
                _hideConfirmPassword,
              ),
              obscureText: _hideConfirmPassword,
            ),
          ],
        ),
      ),
      actions: [
        _submitButton(context),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          child: Text("cancel-label".tr()),
        ),
      ],
    );
  }

  BlocConsumer _submitButton(BuildContext context) {
    return BlocConsumer<UpdateUserBloc, UpdateUserInitial>(
      listener: (context, state) {
        if (state.status is FormSubmissionSuccessful) {
          _passwordController.text = "";
          _confirmPasswordController.text = "";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("password-updated").tr(),
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else if (state.status is FormSubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                (state.status as FormSubmissionFailed).message,
              ),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status is FormSubmitting) {
          return const CircularProgressIndicator();
        }
        return ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<UpdateUserBloc>().add(UserIdChangedEvent(user.id));
              context.read<UpdateUserBloc>().add(const UpdateUserSubmitEvent());
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          child: Text(
            "update-label".tr(),
          ),
        );
      },
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _hideConfirmPassword = !_hideConfirmPassword;
    });
  }
}
