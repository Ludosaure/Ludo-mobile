import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: MediaQuery.of(context).size.height * 0.075,
      title: Image(
        image: const AssetImage('assets/ludosaure_icn.png'),
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.width * 0.15,
      ),
      centerTitle: true,
      leading: Container(
        width: 500,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Text(
            '2 Bis Boulevard Cahours 35150 Janzé',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      leadingWidth: 500,
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
          child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Du Lun. Au Sam.",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                        text: "\n9H30 - 19H",
                      ),
                    ]),
              )),
        ),
      ],
    );
  }
}
