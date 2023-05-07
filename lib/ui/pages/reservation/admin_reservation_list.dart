import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminReservationList extends StatelessWidget {
  const AdminReservationList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          width: MediaQuery.of(context).size.width * 0.85,
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
              const Text("Retards"),
              const Spacer(),
              TextButton(
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(0.0),
                ),
                onPressed: () {
                  print("voir tout pressed");
                },
                child: Text("Voir tout"),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                child: ListTile(
                  leading: const Icon(Icons.person),
                  onTap: () {
                    context.go('/reservation/$index');
                  },
                  title: Text("Nom"),
                  subtitle: Text("Date"),
                  trailing: Text("Prix €"),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
