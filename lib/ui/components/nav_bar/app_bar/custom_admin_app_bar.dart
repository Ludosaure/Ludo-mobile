import 'package:flutter/material.dart';

class AdminAppBar extends StatelessWidget {
  const AdminAppBar({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.85),
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
        child: const Center(
          child: Text(
            '2 Bis Boulevard Cahours 35150 Janzé',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      leadingWidth: 500,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
        ),
      ],
    );
  }
}
