import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/domain/use_cases/register/register_bloc.dart';
import 'package:ludo_mobile/ui/components/custom_back_button.dart';
import 'package:ludo_mobile/ui/components/form_field_decoration.dart';
import 'package:ludo_mobile/ui/components/sized_box_20.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/app_dimensions.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: AppDimensions.formWidth,
              child: Column(
                verticalDirection: VerticalDirection.down,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  _titleRow(),
                  const Flexible(
                    flex: 1,
                    child: SizedBox(
                      height: 32,
                    ),
                  ),
                  Flexible(
                    flex: 30,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: _registerForm(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        verticalDirection: VerticalDirection.down,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            validator: RequiredValidator(errorText: 'form.field-required-msg'.tr()),
            onChanged: (value) {
              context.read<RegisterBloc>().add(LastnameChangedEvent(value));
            },
            autocorrect: false,
            decoration: FormFieldDecoration.textField("name-label".tr()),
          ),
          const SizedBox20(),
          TextFormField(
            validator: RequiredValidator(errorText: 'form.field-required-msg'.tr()),
            decoration: FormFieldDecoration.textField("firstname-label".tr()),
            onChanged: (value) {
              context.read<RegisterBloc>().add(FirstnameChangedEvent(value));
            },
          ),
          const SizedBox20(),
          TextFormField(
            validator: MultiValidator([
              RequiredValidator(errorText: 'form.field-required-msg'.tr()),
              EmailValidator(errorText: 'form.invalid-email-msg'.tr()),
            ]),
            onChanged: (value) {
              context.read<RegisterBloc>().add(EmailChangedEvent(value));
            },
            decoration: FormFieldDecoration.textField("email-label".tr()),
          ),
          const SizedBox20(),
          TextFormField(
            validator: _validatePhoneNumber,
            onChanged: (value) {
              context.read<RegisterBloc>().add(PhoneChangedEvent(value));
            },
            decoration: FormFieldDecoration.textField("phone-label".tr()),
          ),
          const SizedBox20(),
          TextFormField(
            controller: _passwordController,
            validator: MultiValidator([
              RequiredValidator(errorText: 'form.field-required-msg'.tr()),
              MinLengthValidator(8, errorText: 'form.password-min-length-msg'.tr(args: ['8'])),
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
              context.read<RegisterBloc>().add(PasswordChangedEvent(value));
            },
            decoration: FormFieldDecoration.passwordField(
              "password-label".tr(),
              _togglePasswordVisibility,
              _hidePassword,
            ),
            obscureText: _hidePassword,
          ),
          const SizedBox20(),
          TextFormField(
            controller: _confirmPasswordController,
            validator: (String? value) {
              if (value != _passwordController.text) {
                return 'form.password-not-matching-msg'.tr();
              }
              return null;
            },
            onChanged: (value) {
              context
                  .read<RegisterBloc>()
                  .add(PasswordConfirmationChangedEvent(value));
            },
            decoration: FormFieldDecoration.passwordField(
              "password-confirm-label".tr(),
              _toggleConfirmPasswordVisibility,
              _hideConfirmPassword,
            ),
            obscureText: _hideConfirmPassword,
          ),
          const SizedBox20(),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: _acceptTermsText(context),
            ),
          ),
          const SizedBox20(),
          _submitButton(context),
          const SizedBox20(),
          _loginText(context)
        ],
      ),
    );
  }

  BlocConsumer _submitButton(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterInitial>(
      listener: (context, state) {
        if (state.status is FormSubmissionSuccessful) {
          context.go(Routes.registerSuccess.path);
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //   '/register-success',
          //   (route) => false,
          // );
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
              context.read<RegisterBloc>().add(const RegisterSubmitEvent());
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
            "register-label",
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
      children: [
        !kIsWeb ? const CustomBackButton() : const SizedBox(),
        const Spacer(),
        const Text(
          "register-title",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ).tr(),
        const Spacer(),
      ],
    );
  }

  Widget _loginText(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "${"already-have-account-msg".tr()} ",
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF838486),
        ),
        children: <TextSpan>[
          TextSpan(
            text: "login-label".tr(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.go(Routes.login.path);
                // Navigator.pushNamed(context, '/login');
              },
          ),
        ],
      ),
    );
  }

  Widget _acceptTermsText(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "register-agreement-msg".tr(),
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF838486),
        ),
        children: <TextSpan>[
          TextSpan(
            text: "terms-of-use".tr(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                context.go(Routes.terms.path);
              },
          ),
        ],
      ),
    );
  }

  //TODO voir pour mettre dans un fichier à part et pouvoir le réutiliser
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'form.phone-number-required-msg'.tr();
    }
    if (value.length != 10) {
      return 'form.phone-number-invalid-msg'.tr();
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'form.phone-number-invalid-msg'.tr();
    }

    return null;
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
