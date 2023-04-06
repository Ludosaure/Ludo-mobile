import 'package:flutter/material.dart';

import '../../tools/responsive_layout.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //size
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: ResponsiveLayout(
        mobile: _buildLandingPage(_size, context),
        tablet: Center(
          child: Container(
            width: _size.width * 0.5,
            height: _size.height * 0.6,
            child: _buildLandingPage(_size, context),
          )
        ),
        computer: Center(
          //with a border
          child: Container(
            width: _size.width * 0.3,
            height: _size.height * 0.6,
            child: _buildLandingPage(_size, context),
          )
        )
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
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            //align text to the center
            "Retrouvez tous vos jeux de société préférés",
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF838486),
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
              minimumSize: Size(size.width * 0.9, 40),
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
              minimumSize: Size(size.width * 0.9, 40),
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
                minimumSize: Size(size.width * 0.9, 40),
              ),
              child: const Text('Continuer sans compte')),
        ],
      ),
    );
  }
}
