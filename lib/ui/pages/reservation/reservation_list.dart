import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/data/repositories/reservation/sorted_reservations.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/reservation_status.dart';
import 'package:ludo_mobile/domain/use_cases/get_reservation/get_reservation_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/invoice/download_invoice_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/list_all_reservations/list_all_reservations_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/user_reservations/user_reservations_cubit.dart';
import 'package:ludo_mobile/injection.dart';
import 'package:ludo_mobile/ui/components/circle-avatar.dart';
import 'package:ludo_mobile/ui/pages/reservation/reservation_detail_page.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class ReservationList extends StatefulWidget {
  //TODO c'est de la grosse merde mais pour l'instant ça fera l'affaire
  SortedReservations reservations;
  final User connectedUser;

  ReservationList({
    Key? key,
    required this.reservations,
    required this.connectedUser,
  }) : super(key: key);

  @override
  State<ReservationList> createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  late Reservation selectedReservation = sortedReservations.all[0];

  User get connectedUser => widget.connectedUser;

  SortedReservations get sortedReservations => widget.reservations;
  set sortedReservations(SortedReservations value) =>
      widget.reservations = value;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool displayDesktopLayout = connectedUser.isAdmin() &&
            kIsWeb &&
            ResponsiveWrapper.of(context).isLargerThan(DESKTOP) ||
        kIsWeb &&
            ResponsiveWrapper.of(context).isLargerThan(MOBILE) &&
            !connectedUser.isAdmin();

    return displayDesktopLayout
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: VerticalDirection.down,
            children: [
              SizedBox(
                width: connectedUser.isAdmin()
                    ? size.width * 0.22
                    : size.width * 0.3,
                child: _buildMobile(context),
              ),
              SizedBox(
                width: connectedUser.isAdmin()
                    ? size.width * 0.55
                    : size.width * 0.6,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: locator<ListAllReservationsCubit>(),
                    ),
                    BlocProvider.value(
                      value: locator<GetReservationCubit>(),
                    ),
                    BlocProvider.value(
                      value: locator<UserReservationsCubit>(),
                    ),
                    BlocProvider.value(
                      value: locator<DownloadInvoiceCubit>(),
                    ),
                  ],
                  child: ReservationDetailsPage(
                    reservationId: selectedReservation.id,
                    user: connectedUser,
                  ),
                ),
              ),
            ],
          )
        : _buildMobile(context);
  }

  Widget _buildReservationList(List<Reservation> reservations) {
    return RefreshIndicator(
      onRefresh: () async {
        if(connectedUser.isAdmin()) {
          BlocProvider.of<ListAllReservationsCubit>(context).listReservations();
        } else {
          BlocProvider.of<UserReservationsCubit>(context).getMyReservations();
        }
      },
      child: connectedUser.isAdmin()
          ? _buildAdminList(context, reservations)
          : _buildClientList(context, reservations),
    );
  }

  Widget _buildClientList(BuildContext context, List<Reservation> reservations) {
    return BlocConsumer<UserReservationsCubit, UserReservationsState>(
      listener: (context, state) {
        if (state is UserReservationsSuccess) {
          setState(() {
            sortedReservations = state.reservations;
          });
        }
      },
      builder: (context, state) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            Reservation reservation = reservations[index];
            Color color;

            switch (reservation.status) {
              case ReservationStatus.LATE:
                color = Colors.red[200]!;
                break;
              case ReservationStatus.RETURNED:
                color = Colors.green[200]!;
                break;
              default:
                color = Colors.white;
            }

            return Card(
              color: color,
              elevation:
              selectedReservation.id == reservation.id ? 10.0 : 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: CustomCircleAvatar(
                  color: Colors.black,
                  userProfilePicture: reservation.user!.profilePicturePath,
                ),
                onTap: () {
                  final bool displayDesktopLayout = connectedUser.isAdmin() &&
                      kIsWeb &&
                      ResponsiveWrapper.of(context)
                          .isLargerThan(DESKTOP) ||
                      kIsWeb &&
                          ResponsiveWrapper.of(context)
                              .isLargerThan(MOBILE) &&
                          !connectedUser.isAdmin();
                  if (!displayDesktopLayout) {
                    context.push(
                        '${Routes.reservations.path}/${reservation.id}');
                  } else {
                    setState(() {
                      selectedReservation = reservation;
                    });
                  }
                },
                title: Text(
                  "#${reservation.reservationNumber} ${reservation.createdBy.firstname} ${reservation.createdBy.lastname}",
                ),
                subtitle: Text(_getPeriod(reservation)),
                trailing: Text("${reservation.amount.toStringAsFixed(2)} €"),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAdminList(BuildContext context, List<Reservation> reservations) {
    return BlocConsumer<ListAllReservationsCubit, ListAllReservationsState>(
      listener: (context, state) {
        if (state is ListReservationsSuccess) {
          setState(() {
            sortedReservations = state.reservations;
          });
        }
      },
      builder: (context, state) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            Reservation reservation = reservations[index];
            Color color;

            switch (reservation.status) {
              case ReservationStatus.LATE:
                color = Colors.red[200]!;
                break;
              case ReservationStatus.RETURNED:
                color = Colors.green[200]!;
                break;
              default:
                color = Colors.white;
            }

            return Card(
              color: color,
              elevation:
              selectedReservation.id == reservation.id ? 10.0 : 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                leading: CustomCircleAvatar(
                  color: Colors.black,
                  userProfilePicture: reservation.user!.profilePicturePath,
                ),
                onTap: () {
                  final bool displayDesktopLayout = connectedUser.isAdmin() &&
                      kIsWeb &&
                      ResponsiveWrapper.of(context)
                          .isLargerThan(DESKTOP) ||
                      kIsWeb &&
                          ResponsiveWrapper.of(context)
                              .isLargerThan(MOBILE) &&
                          !connectedUser.isAdmin();
                  if (!displayDesktopLayout) {
                    context.push(
                        '${Routes.reservations.path}/${reservation.id}');
                  } else {
                    setState(() {
                      selectedReservation = reservation;
                    });
                  }
                },
                title: Text(
                  "#${reservation.reservationNumber} ${reservation.createdBy.firstname} ${reservation.createdBy.lastname}",
                ),
                subtitle: Text(_getPeriod(reservation)),
                trailing: Text("${reservation.amount.toStringAsFixed(2)} €"),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMobile(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildTabBar(context),
          Expanded(
            child: TabBarView(
              children: [
                _buildReservationList(sortedReservations.all),
                _buildReservationList(sortedReservations.overdue),
                _buildReservationList(sortedReservations.current),
                _buildReservationList(sortedReservations.returned),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      isScrollable: true,
      indicatorColor: Theme.of(context).colorScheme.primary,
      tabs: [
        Tab(
          child: const Text(
            "all.fem",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        Tab(
          child: const Text(
            "reservation-late",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        Tab(
          child: const Text(
            "reservation-running",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
        Tab(
          child: const Text(
            "reservation-returned",
            style: TextStyle(color: Colors.black),
          ).tr(),
        ),
      ],
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
