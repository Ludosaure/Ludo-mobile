import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/reservation_status.dart';
import 'package:ludo_mobile/domain/use_cases/get_reservation/get_reservation_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/user_reservations/user_reservations_cubit.dart';
import 'package:ludo_mobile/ui/components/custom_back_button.dart';
import 'package:ludo_mobile/ui/components/list_header.dart';
import 'package:ludo_mobile/ui/components/nav_bar/app_bar/admin_app_bar.dart';
import 'package:ludo_mobile/ui/components/new_conversation_alert.dart';
import 'package:ludo_mobile/ui/pages/game/list/game_tile.dart';
import 'package:ludo_mobile/ui/pages/invoices/InvoicesList.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ReservationDetailsPage extends StatefulWidget {
  final String reservationId;
  final User user;

  const ReservationDetailsPage({
    Key? key,
    required this.reservationId,
    required this.user,
  }) : super(key: key);

  @override
  State<ReservationDetailsPage> createState() => _ReservationDetailsPageState();
}

class _ReservationDetailsPageState extends State<ReservationDetailsPage> {
  late Reservation reservation;

  User get user => widget.user;

  @override
  Widget build(BuildContext context) {
    final bool displayDesktopLayout = user.isAdmin() &&
        kIsWeb &&
        ResponsiveWrapper.of(context).isLargerThan(TABLET) ||
        kIsWeb &&
            ResponsiveWrapper.of(context).isLargerThan(MOBILE) &&
            !user.isAdmin();

    return Scaffold(
      appBar: !displayDesktopLayout ? _buildAppBar(context) : null,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<GetReservationCubit, GetReservationState>(
      builder: (context, state) {
        if (state is GetReservationInitial) {
          BlocProvider.of<GetReservationCubit>(context)
              .getReservation(widget.reservationId);
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetReservationLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetReservationSuccess) {
          reservation = state.reservation;
          return _buildMobileReservationContent(context);
        }
        return Container();
      },
      listener: (context, state) {
        if (state is GetReservationError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
    );
  }

  Widget _buildMobileReservationContent(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          children: [
            _buildReservationInfos(context),
            _buildReservationDetails(context),
            _buildGameList(context),
            const SizedBox(height: 20),
            _buildReservationSynthesis(context),
            const SizedBox(height: 20),
            InvoicesList(invoices: reservation.invoices!),
            _buildReservationInfoText(context),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationDetails(BuildContext context) {
    Color color = reservation.status == ReservationStatus.LATE
        ? Colors.red[200]!
        : Colors.black;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      verticalDirection: VerticalDirection.down,
      children: [
        const SizedBox(height: 10),
        Text(
          "date-period".tr(
            namedArgs: {
              "startDate": DateFormat(AppConstants.DATE_TIME_FORMAT_LONG, 'FR')
                  .format(reservation.startDate),
              "endDate": DateFormat(AppConstants.DATE_TIME_FORMAT_LONG, 'FR')
                  .format(reservation.endDate)
            },
          ),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          "nb-weeks".tr(namedArgs: {"nbWeeks": reservation.nbWeeks.toString()}),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Text(
            reservation.status.label,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildReturnedGamesButton(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            _showConfirmReturnedGamesDialog(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Text(
            "validate-games-returned".tr(),
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReservationSynthesis(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTotalAmount(context),
            const SizedBox(height: 10),
            FutureBuilder<Widget>(
              future: _buildContactUser(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                return snapshot.data!;
              },
            ),
            if (reservation.status != ReservationStatus.RETURNED &&
                reservation.status != ReservationStatus.CANCELED &&
                user.isAdmin())
              _buildReturnedGamesButton(context),
          ],
        ),
      ),
    );
  }

  Future<Widget> _buildContactUser(BuildContext context) async {
    var connectedUserId = user.id;
    if (reservation.user!.id == connectedUserId) {
      return Container();
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "contact-user".tr(),
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.email,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: reservation.user!.email))
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "email-copied"
                            .tr(namedArgs: {"email": reservation.user!.email}),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      duration: const Duration(seconds: 5),
                    ),
                  );
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.message,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () async {
                _showNewMessageDialog(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalAmount(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "total-amount".tr(),
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (reservation.appliedPlan != null)
              Text(
                "reduction".tr(),
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${reservation.amount.toStringAsFixed(2)} €",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 10),
            if (reservation.appliedPlan != null)
              Text(
                "${reservation.appliedPlan!.reduction}%",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildGameList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ListHeader(
          title: "details".tr(),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: reservation.games.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            Game game = reservation.games[index];
            return GestureDetector(
              onTap: () {
                context.push(
                  '${Routes.game.path}/${game.id}',
                );
              },
              child: GameTile(
                adminView: false,
                game: game,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildReservationInfos(BuildContext context) {
    return Text(
      'reservation-details-title'.tr(namedArgs: {
        'number': reservation.reservationNumber.toString(),
        'firstname': reservation.user!.firstname,
        'lastname': reservation.user!.lastname,
      }),
      style: Theme.of(context).textTheme.headline6,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    if (ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)) {
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomBackButton(),
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.20,
      );
    }
    return const AdminAppBar().build(context);
  }

  void _showConfirmReturnedGamesDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("validate-games-returned".tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("validate-games-returned-confirm".tr()),
              const SizedBox(height: 10),
              Text(
                "irreversible-action".tr(),
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text("confirm.yes".tr()),
              onPressed: () {
                parentContext
                    .read<UserReservationsCubit>()
                    .returnReservationGames(reservation.id);
                setState(() {
                  reservation.returned = true;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("games-returned-successfully").tr(),
                    duration: const Duration(seconds: 4),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: Text("confirm.no".tr()),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showNewMessageDialog(BuildContext parentContext) async {
    var connectedUserId = user.id;
    if (connectedUserId == reservation.user!.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("cant-send-message-to-yourself").tr(),
          duration: const Duration(seconds: 4),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
    showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return NewConversationAlert(userTargetMail: reservation.user!.email);
      },
    );
  }

  Widget _buildReservationInfoText(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: const Text(
        "reservation-details-info",
        style: TextStyle(
          fontSize: 15,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.end,
      ).tr(),
    );
  }
}
