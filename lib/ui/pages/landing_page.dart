import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          width: _size.width * 0.5,
          height: _size.height * 0.7,
          child: _buildLandingPage(_size, context),
        ),
      ),
    );
  }

  Widget _buildLandingPage(Size size, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Image(
              image: const AssetImage('assets/ludosaure_icn.png'),
              width: size.width * 0.6,
              height: 250,
            ),
          ),
          Flexible(
            child: SizedBox(
              height: size.height * 0.06,
            ),
          ),
          const Text(
            "La Ludosaure",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Retrouvez tous vos jeux de société préférés",
            style: TextStyle(
              fontSize: ResponsiveValue(
                context,
                defaultValue: 15.0,
                valueWhen: [
                  const Condition.smallerThan(name: MOBILE, value: 10.0),
                  const Condition.largerThan(name: TABLET, value: 20.0),
                ],
              ).value,
              color: const Color(0xFF838486),
            ),
            textAlign: TextAlign.center,
          ),
          Flexible(
            child: SizedBox(
              height: size.height * 0.03,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              maximumSize: const Size(400, 40),
              minimumSize: const Size(400, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'Se connecter',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/register');
            },
            style: ElevatedButton.styleFrom(
              maximumSize: const Size(400, 40),
              minimumSize: const Size(400, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.grey[300],
            ),
            child: const Text(
              'Créer un compte',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            style: TextButton.styleFrom(
              alignment: Alignment.centerRight,
              minimumSize: const Size(400, 40),
              maximumSize: const Size(400, 40),
            ),
            child: Text(
              'Continuer sans compte',
              style: TextStyle(
                fontSize: ResponsiveValue(
                  context,
                  defaultValue: 15.0,
                  valueWhen: [
                    const Condition.smallerThan(name: MOBILE, value: 10.0),
                    const Condition.largerThan(name: TABLET, value: 20.0),
                  ],
                ).value,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
