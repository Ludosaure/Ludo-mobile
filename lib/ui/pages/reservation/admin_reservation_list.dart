import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:ludo_mobile/domain/reservation_status.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class AdminReservationList extends StatelessWidget {
  final List<Reservation> reservations;

  const AdminReservationList({
    Key? key,
    required this.reservations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      verticalDirection: VerticalDirection.down,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildListHeader(
          context,
          "Toutes",
        ),
        Flexible(
          fit: FlexFit.loose,
          child: _buildReservationList(
            reservations,
          ),
        ),
      ],
    );
  }

  Widget _buildListHeader(BuildContext context, String title) {
    return Container(
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
          Text(title),
        ],
      ),
    );
  }

  Widget _buildReservationList(List<Reservation> reservations) {
    return ListView.builder(
      itemCount: reservations.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        Reservation reservation = reservations[index];
        Color color = reservation.status == ReservationStatus.LATE ? Colors.red[200]! : Colors.white;
        return Card(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            leading: const Icon(Icons.person),
            onTap: () {
              context.go('${Routes.reservations.path}/$index');
            },
            title: Text(
                "${reservation.createdBy.firstname} ${reservation.createdBy.lastname}"),
            subtitle: Text(_getPeriod(reservation)),
            trailing: Text("${reservation.amount} €"),
          ),
        );
      },
    );
  }

  String _getPeriod(Reservation reservation) {
    String period = "";
    period =
        "Du ${DateFormat('d MMMM', 'FR').format(reservation.startDate)} au "
        "${DateFormat('d MMMM yyyy', 'FR').format(reservation.endDate)}";
    return period;
  }
}
