import 'package:flutter/material.dart';

class ValidateButton extends StatelessWidget {
  const ValidateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        padding: const EdgeInsets.all(0),
        onPressed: null,
        icon: const Icon(
          Icons.check,
          color: Colors.white,
          size: 25,
        ),
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(2),
        ),
      ),
    );
  }
}
