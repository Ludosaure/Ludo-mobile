import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //size
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          //prevent overflow
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Flexible(
              child: Image(
                image: const AssetImage('assets/ludosaure_icn.png'),
                width: _size.width * 0.6,
                height: 200,
              ),
            ),
            Flexible(
              child: SizedBox(
                height: _size.height * 0.06,
              ),
            ),
            const Text(
              "La Ludosaure",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Retrouvez tous vos jeux de société préférés",
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF838486),
              ),
            ),
            Flexible(
              child: SizedBox(
                height: _size.height * 0.03,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              //the color of the button is lighter than the primary color
              style: ElevatedButton.styleFrom(
                minimumSize: Size(_size.width * 0.9, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                'Se connecter',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(_size.width * 0.9, 40),
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
                  minimumSize: Size(_size.width * 0.9, 40),
                ),
                child: const Text('Continuer sans compte')),
          ],
        ),
      ),
    );
  }
}
