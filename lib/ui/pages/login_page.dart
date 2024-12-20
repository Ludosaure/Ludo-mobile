import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/login/login_bloc.dart';
import 'package:ludo_mobile/ui/components/custom_back_button.dart';
import 'package:ludo_mobile/ui/components/form_field_decoration.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:ludo_mobile/utils/app_dimensions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: AppDimensions.formWidth,
                  child: _titleRow(),
                ),
                const Flexible(
                  child: SizedBox(
                    height: 50,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Image(
                    image: const AssetImage(AppConstants.APP_LOGO),
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 250,
                  ),
                ),
                const Flexible(
                  child: SizedBox(
                    height: 50,
                  ),
                ),
                SizedBox(
                  width: AppDimensions.formWidth,
                  child: _loginForm(),
                ),
                const Flexible(
                  child: SizedBox(
                    height: 5,
                  ),
                ),
                _registerText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginForm() {
    return Form(
      key: _formKey,
      child: Column(children: [
        TextFormField(
          enabled: !_submitting,
          validator: RequiredValidator(
            errorText: "form.email-required-msg".tr(),
          ),
          decoration: FormFieldDecoration.textField("email-label".tr()),
          onChanged: (value) {
            context.read<LoginBloc>().add(EmailChangedEvent(value.trim()));
          },
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          enabled: !_submitting,
          validator: RequiredValidator(
            errorText: "form.password-required-msg".tr(),
          ),
          decoration: FormFieldDecoration.passwordField(
            "password-label".tr(),
            _togglePasswordVisibility,
            _hidePassword,
          ),
          obscureText: _hidePassword,
          onChanged: (value) {
            context.read<LoginBloc>().add(PasswordChangedEvent(value));
          },
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          verticalDirection: VerticalDirection.down,
          children: [
            /*TextButton(
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => _forgottenPasswordDialog(context),
                );
              },
              child: const Text(
                "password-forgotten-label",
              ).tr(),
            ),*/
            TextButton(
              style: TextButton.styleFrom(
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.all(0),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => _confirmAccountDialog(context),
                );
              },
              child: const Text(
                "confirm-email-not-received-msg",
              ).tr(),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        _submitButton(context),
      ]),
    );
  }

  BlocConsumer _submitButton(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status is FormSubmissionSuccessful) {
          final user = state.loggedUser as User;

          if (user.isAdmin()) {
            context.go(Routes.homeAdmin.path);
          } else {
            context.go(Routes.home.path);
          }
        } else if (state.status is FormSubmissionFailed) {
          setState(() {
            _submitting = false;
          });

          FormSubmissionFailed status = state.status as FormSubmissionFailed;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(status.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status is FormSubmitting) {
          return CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          );
        }
        return ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              context.read<LoginBloc>().add(const LoginSubmitEvent());
              _submitting = true;
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: AppDimensions.largeButtonSize,
            maximumSize: AppDimensions.largeButtonSize,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text(
            "login-label",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ).tr(),
        );
      },
    );
  }

  Widget _titleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        kIsWeb || _submitting ?  const SizedBox() : const CustomBackButton(),
        const Spacer(),
        const Text(
          "login-title",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ).tr(),
        const Spacer(),
      ],
    );
  }

  Widget _registerText(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "no-account-yet-label".tr(),
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF838486),
        ),
        children: <TextSpan>[
          TextSpan(
            text: "register-label".tr(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.go(Routes.register.path);
              },
          ),
        ],
      ),
    );
  }

  Widget _forgottenPasswordDialog(BuildContext context) {
    return AlertDialog(
      title: const Text("password-forgotten-title").tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "password-forgotten-subtitle",
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF838486),
            ),
          ).tr(),
          TextFormField(
            decoration: InputDecoration(
              labelText: "email-label".tr(),
              hintText: "email-placeholder".tr(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    );
  }

  Widget _confirmAccountDialog(BuildContext context) {
    final confirmAccountFormKey = GlobalKey<FormState>();
    String email = "";

    return AlertDialog(
      title: const Text("confirm-account-title").tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "confirm-account-subtitle",
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF838486),
            ),
          ).tr(),
          Form(
            key: confirmAccountFormKey,
            child: TextFormField(
              onChanged: (value) {
                email = value;
              },
              validator: MultiValidator([
                RequiredValidator(
                  errorText: "form.email-required-msg".tr(),
                ),
                EmailValidator(
                  errorText: "form.email-invalid-msg".tr(),
                ),
              ]),
              decoration: InputDecoration(
                labelText: "email-label".tr(),
                hintText: "email-placeholder".tr(),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (confirmAccountFormKey.currentState!.validate()) {
              context
                  .read<LoginBloc>()
                  .add(ResendConfirmAccountEmailEvent(email));
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
          child: const Text("send-label").tr(),
        ),
      ],
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }
}
