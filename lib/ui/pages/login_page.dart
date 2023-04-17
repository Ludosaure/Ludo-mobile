import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/domain/use_cases/login/login_bloc.dart';
import 'package:ludo_mobile/utils/app_dimensions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _hidePassword = true;
  Icon _passwordIcon = const Icon(Icons.visibility_off);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Flexible(
                  child: SizedBox(
                    height: 50,
                  ),
                ),
                _titleRow(context),
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
          validator:
              RequiredValidator(errorText: "Veuillez saisir votre email"),
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            labelText: 'Email',
          ),
          onChanged: (value) {
            context.read<LoginBloc>().add(EmailChangedEvent(value));
          },
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          validator: RequiredValidator(
              errorText: "Veuillez saisir votre mot de passe"),
          decoration: InputDecoration(
            isDense: true,
            border: const OutlineInputBorder(),
            labelText: 'Mot de passe',
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _hidePassword = !_hidePassword;
                  _passwordIcon = _hidePassword
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility);
                });
              },
              icon: _passwordIcon,
            ),
          ),
          obscureText: _hidePassword,
          onChanged: (value) {
            context.read<LoginBloc>().add(PasswordChangedEvent(value));
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text(
                "Mot de passe oublié ?",
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {

            if (state.status is FormSubmissionSuccessful) {
              Navigator.pushNamed(context, '/home');
            } else if (state.status is FormSubmissionFailed) {
              FormSubmissionFailed status = state.status as FormSubmissionFailed;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(status.message),
                  backgroundColor: Theme.of(context).errorColor,
                ),
              );
            }
          },
          builder: (context, state) {
            return state.status is FormSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<LoginBloc>().add(const LoginSubmitEvent());
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
                      "Se connecter",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
          },
        ),
      ]),
    );
  }

  Widget _titleRow(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        const Flexible(
          child: SizedBox(
            width: 20,
          ),
        ),
        const Text(
          "Connexion",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _registerText(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "Vous n'avez pas encore de compte ? ",
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF838486),
        ),
        children: <TextSpan>[
          TextSpan(
            text: "S'inscrire",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, '/register');
              },
          ),
        ],
      ),
    );
  }
}
