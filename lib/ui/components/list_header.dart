import 'package:flutter/material.dart';

class ListHeader extends StatelessWidget {
  final String title;
  const ListHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        verticalDirection: VerticalDirection.down,
        children: [
          Text(title, style: const TextStyle(fontSize: 18.0)),
        ],
      ),
    );
  }
}
