import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:ludo_mobile/domain/use_cases/login/login_bloc.dart';

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
              _loginForm(),
              const Flexible(
                child: SizedBox(
                  height: 5,
                ),
              ),
              _registerRow(context),
            ],
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
          validator: RequiredValidator(errorText: "Veuillez entrer votre email"),
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
          validator: RequiredValidator(errorText: "Veuillez entrer votre mot de passe"),
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
            //ou state.status == "success"
            //ou state.status == LoginSuccess
            if(state is LoginSuccess) {
              Navigator.pushNamed(context, '/home');
            }
            //else show error message
          },
          builder: (context, state) {
            return ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<LoginBloc>().add(const LoginSubmitEvent());
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 40),
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

  Widget _registerRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Vous n'avez pas encore de compte ?",
          style: TextStyle(
            fontSize: 15,
            color: Color(0xFF838486),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/register');
          },
          child: const Text(
            "S'inscrire",
          ),
        ),
      ],
    );
  }
}
