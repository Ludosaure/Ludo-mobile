import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:ludo_mobile/domain/reservation_status.dart';
import 'package:ludo_mobile/domain/use_cases/get_reservation/get_reservation_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/user_reservations/user_reservations_cubit.dart';
import 'package:ludo_mobile/firebase/service/firebase_database_service.dart';
import 'package:ludo_mobile/ui/components/custom_back_button.dart';
import 'package:ludo_mobile/ui/components/form_field_decoration.dart';
import 'package:ludo_mobile/ui/components/list_header.dart';
import 'package:ludo_mobile/ui/components/nav_bar/app_bar/admin_app_bar.dart';
import 'package:ludo_mobile/ui/components/new_conversation_alert.dart';
import 'package:ludo_mobile/ui/pages/game/list/game_tile.dart';
import 'package:ludo_mobile/ui/pages/invoices/InvoicesList.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ReservationDetailsPage extends StatefulWidget {
  final String reservationId;

  const ReservationDetailsPage({Key? key, required this.reservationId})
      : super(key: key);

  @override
  State<ReservationDetailsPage> createState() => _ReservationDetailsPageState();
}

class _ReservationDetailsPageState extends State<ReservationDetailsPage> {
  late Reservation reservation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocConsumer<GetReservationCubit, GetReservationState>(
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
            return ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                ? _buildMobileReservationContent(context)
                : _buildDesktopReservationContent(context);
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
      ),
    );
  }

  Widget _buildDesktopReservationContent(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 15, 40, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          verticalDirection: VerticalDirection.down,
          children: [
            _buildDesktopReservationHeader(context),
            _buildDesktopReservationBody(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopReservationBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildGameDetails(context),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.35,
                child: _buildReservationSynthesis(context),
              ),
            ),
          ],
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: InvoicesList(invoices: reservation.invoices!),
        ),
      ],
    );
  }

  Widget _buildDesktopReservationHeader(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomBackButton(),
            _buildReservationInfos(context),
          ],
        ),
        const SizedBox(height: 20),
        _buildReservationDetails(context),
      ],
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
            _buildGameDetails(context),
            const SizedBox(height: 20),
            _buildReservationSynthesis(context),
            const SizedBox(height: 20),
            InvoicesList(invoices: reservation.invoices!),
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
          "date-period".tr(namedArgs: {
            "startDate": DateFormat(AppConstants.DATE_TIME_FORMAT_LONG, 'FR')
                .format(reservation.startDate),
            "endDate": DateFormat(AppConstants.DATE_TIME_FORMAT_LONG, 'FR')
                .format(reservation.endDate)
          }),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text(
          "nb-weeks".tr(namedArgs: {"nbWeeks": reservation.nbWeeks.toString()}),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              reservation.status.label,
              style: TextStyle(
                fontSize: 16,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
    return Card(
      color: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTotalAmount(context),
            const SizedBox(height: 10),
            _buildContactUser(context),
            if (reservation.status != ReservationStatus.RETURNED &&
                reservation.status != ReservationStatus.CANCELED)
              _buildReturnedGamesButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContactUser(BuildContext context) {
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
                await _showNewMessageDialog(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTotalAmount(BuildContext context) {
    return Row(
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
              "${reservation.amount} €",
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${reservation.appliedPlan.reduction}%",
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

  Widget _buildGameDetails(BuildContext context) {
    if (ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)) {
      return _buildGameList(context);
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: _buildGameList(context),
    );
  }

  _buildGameList(BuildContext context) {
    return Column(
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
              child: GameTile(game: game),
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
    return const AdminAppBar(
      onSortPressed: null, // TODO
      onSearch: null, // TODO
    ).build(context);
  }

  _showConfirmReturnedGamesDialog(BuildContext parentContext) {
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
                    .returnReservation(reservation.id);
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

  _showNewMessageDialog(BuildContext parentContext) async {
    var connectedUserId =
        (await LocalStorageHelper.getUserFromLocalStorage())!.id;
    if (connectedUserId == reservation.user!.id) {
      return ScaffoldMessenger.of(context).showSnackBar(
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
}
