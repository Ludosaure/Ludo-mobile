import 'package:flutter/material.dart';

class SizedBox20 extends StatelessWidget {
  const SizedBox20({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: SizedBox(
        height: 20,
      ),
    );
  }
}
