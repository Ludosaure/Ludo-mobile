import 'package:flutter/material.dart';

class AdminAppBar extends StatelessWidget {
  const AdminAppBar({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: MediaQuery.of(context).size.height * 0.08,
      title: const Text("La Ludosaure",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          )),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Image(
          image: const AssetImage('assets/ludosaure_icn.png'),
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.width * 0.15,
        ),
      ),
      leadingWidth: MediaQuery.of(context).size.width * 0.25,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.filter_list_sharp,
            color: Colors.black,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
      ],
      elevation: 1.0,
    );
  }
}
