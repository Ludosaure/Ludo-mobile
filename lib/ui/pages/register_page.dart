import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/domain/use_cases/register/register_bloc.dart';
import 'package:ludo_mobile/ui/components/custom_back_button.dart';
import 'package:ludo_mobile/ui/components/sized_box_20.dart';
import 'package:ludo_mobile/ui/components/form_field_decoration.dart';
import 'package:ludo_mobile/utils/app_dimensions.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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
            validator: RequiredValidator(errorText: 'Ce champ est requis'),
            onChanged: (value) {
              context.read<RegisterBloc>().add(LastnameChangedEvent(value));
            },
            autocorrect: false,
            decoration: FormFieldDecoration.textField("Nom"),
          ),
          const SizedBox20(),
          TextFormField(
            validator: RequiredValidator(errorText: 'Ce champ est requis'),
            decoration: FormFieldDecoration.textField("Prénom"),
            onChanged: (value) {
              context.read<RegisterBloc>().add(FirstnameChangedEvent(value));
            },
          ),
          const SizedBox20(),
          TextFormField(
            validator: MultiValidator([
              RequiredValidator(errorText: 'Ce champ est requis'),
              EmailValidator(errorText: 'Email invalide'),
            ]),
            onChanged: (value) {
              context.read<RegisterBloc>().add(EmailChangedEvent(value));
            },
            decoration: FormFieldDecoration.textField("Email"),
          ),
          const SizedBox20(),
          TextFormField(
            validator: _validatePhoneNumber,
            onChanged: (value) {
              context.read<RegisterBloc>().add(PhoneChangedEvent(value));
            },
            decoration: FormFieldDecoration.textField("Téléphone"),
          ),
          const SizedBox20(),
          TextFormField(
            controller: _passwordController,
            validator: MultiValidator([
              RequiredValidator(errorText: 'Ce champ est requis'),
              MinLengthValidator(8, errorText: '8 caractères minimum'),
              //regex for at least one special character
              PatternValidator(
                r'[!@#$%^&*(),.?":{}|<>]',
                errorText: 'doit contenir au moins un caractère spécial',
              ),
              PatternValidator(r'(?=.*?[A-Z])',
                  errorText: 'doit contenir au moins une majuscule'),
              PatternValidator(r'(?=.*?[a-z])',
                  errorText: 'doit contenir au moins une minuscule'),
              PatternValidator(r'(?=.*?[0-9])',
                  errorText: 'doit contenir au moins un chiffre'),
            ]),
            onChanged: (value) {
              context.read<RegisterBloc>().add(PasswordChangedEvent(value));
            },
            decoration: FormFieldDecoration.passwordField(
              "Mot de passe",
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
                return 'Le mot de passe et la confirmation ne correspondent pas';
              }
              return null;
            },
            onChanged: (value) {
              context
                  .read<RegisterBloc>()
                  .add(PasswordConfirmationChangedEvent(value));
            },
            decoration: FormFieldDecoration.passwordField(
              "Confirmer le mot de passe",
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
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
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
            "S'inscrire",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _titleRow() {
    return Row(
      children: const [
        CustomBackButton(),
        Spacer(),
        Text(
          "Inscription",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget _loginText(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "Vous avez déjà un compte ? ",
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF838486),
        ),
        children: <TextSpan>[
          TextSpan(
            text: "Se connecter.",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, '/login');
              },
          ),
        ],
      ),
    );
  }

  Widget _acceptTermsText(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: "En vous inscrivant vous acceptez les ",
        style: const TextStyle(
          fontSize: 15,
          color: Color(0xFF838486),
        ),
        children: <TextSpan>[
          TextSpan(
            text: "Conditions générales d'utilisation.",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushNamed(context, '/terms-and-conditions');
              },
          ),
        ],
      ),
    );
  }

  //TODO voir pour mettre dans un fichier à part et pouvoir le réutiliser
  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez entrer votre numéro de téléphone';
    }
    if (value.length != 10) {
      return 'Veuillez entrer un numéro de téléphone valide';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Veuillez entrer un numéro de téléphone valide';
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
