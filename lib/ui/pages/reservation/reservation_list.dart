import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:ludo_mobile/domain/reservation_status.dart';
import 'package:ludo_mobile/ui/components/circle-avatar.dart';
import 'package:ludo_mobile/ui/components/list_header.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

class ReservationList extends StatelessWidget {
  final List<Reservation> reservations;

  const ReservationList({
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
        ListHeader(
          title: "all.fem".tr(),
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

  Widget _buildReservationList(List<Reservation> reservations) {
    return ListView.builder(
      itemCount: reservations.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        Reservation reservation = reservations[index];
        Color color = reservation.status == ReservationStatus.LATE
            ? Colors.red[200]!
            : Colors.white;

        return Card(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            leading: CustomCircleAvatar(
              userProfilePicture: reservation.user!.profilePicturePath,
            ),
            onTap: () {
              context.go('${Routes.reservations.path}/${reservation.id}');
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

    period = "date-period".tr(
      namedArgs: {
        "startDate": DateFormat(AppConstants.DATE_TIME_FORMAT_DAY_MONTH, 'FR')
            .format(reservation.startDate),
        "endDate": DateFormat(AppConstants.DATE_TIME_FORMAT_LONG, 'FR')
            .format(reservation.endDate)
      },
    );

    return period;
  }
}
