import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/app_dimensions.dart';

class RegisterSuccessPage extends StatelessWidget {
  const RegisterSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: [
              const Flexible(
                child: SizedBox(
                  height: 50,
                ),
              ),
              Flexible(
                flex: 2,
                child: Image(
                  image: const AssetImage('assets/ludosaure_icn.png'),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 250,
                ),
              ),
              const Flexible(
                child: SizedBox(
                  height: 50,
                ),
              ),
              const Text(
                "Votre compte a bien été créé.",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Flexible(
                child: SizedBox(
                  height: 50,
                ),
              ),
              const Text(
                "Veuillez consulter vos mails pour confirmer votre adresse email.",
                style: TextStyle(
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
              const Flexible(
                child: SizedBox(
                  height: 50,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.go(Routes.login.path);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: AppDimensions.largeButtonSize,
                  maximumSize: AppDimensions.largeButtonSize,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text("Se connecter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
