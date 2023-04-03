import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            scrollDirection: Axis.vertical,

            children: [
              const Flexible(
                child: SizedBox(
                  height: 50,
                ),
              ),
              Row(
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
                    "Inscription",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Flexible(
                child: SizedBox(
                  height: 50,
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prénom',
                  isDense: true,
                ),
              ),
              const Flexible(
                child: SizedBox(
                  height: 20,
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom',
                  isDense: true,
                ),
              ),
              const Flexible(
                child: SizedBox(
                  height: 20,
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  isDense: true,
                ),
              ),
              const Flexible(
                child: SizedBox(
                  height: 20,
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Téléphone',
                  isDense: true,
                ),
              ),
              const Flexible(
                child: SizedBox(
                  height: 20,
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mot de passe',
                  isDense: true,
                ),
              ),
              const Flexible(
                child: SizedBox(
                  height: 20,
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirmation du mot de passe',
                  isDense: true,
                ),
              ),
              const Flexible(
                child: SizedBox(
                  height: 20,
                ),
              ),
              Flexible(
                child: Row(
                  children: [
                    //create a checkbox with no margin or padding
                    Checkbox(
                      value: false,
                      onChanged: (bool? value) {},
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    //use RichText to display a text with a link
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: "J'accepte les ",
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
                                  //open a link
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Flexible(
                child: SizedBox(
                  height: 20,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  //size of screen
                  minimumSize: Size(
                    MediaQuery.of(context).size.width,
                    40,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("S'inscrire"),
              ),
              Expanded(
                child: RichText(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
