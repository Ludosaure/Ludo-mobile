import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:ludo_mobile/domain/reservation_status.dart';
import 'package:ludo_mobile/domain/use_cases/get_reservation/get_reservation_cubit.dart';
import 'package:ludo_mobile/ui/components/custom_back_button.dart';
import 'package:ludo_mobile/ui/components/list_header.dart';
import 'package:ludo_mobile/ui/pages/game/list/game_tile.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
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
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Positioned(
        //   top: 0,
        //   left: 0,
        //   child: SizedBox(
        //     width: size.width * 0.30,
        //     height: size.height * 0.70,
        //     child: _buildReservationImage(context),
        //   ),
        // ),
        // Positioned(
        //   top: size.height * 0.15,
        //   left: size.width * 0.30,
        //   child: SizedBox(
        //     width: size.width * 0.65,
        //     child: _buildNameAndFavorite(context),
        //   ),
        // ),
        // Positioned(
        //   top: size.height * 0.20,
        //   left: size.width * 0.30,
        //   child: SizedBox(
        //     width: size.width * 0.65,
        //     child: _buildReservationDescription(context),
        //   ),
        // ),
        // Positioned(
        //   top: size.height * 0.40,
        //   left: size.width * 0.30,
        //   child: _buildReservationRating(context),
        // ),
        // Positioned(
        //   top: size.height * 0.50,
        //   left: size.width * 0.30,
        //   child: _buildReservationDetailsBottomBar(context),
        // ),
      ],
    );
  }

  Widget _buildMobileReservationContent(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.down,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            child: _buildReservation(context),
          ),
        ],
      ),
    );
  }

  Widget _buildReservation(BuildContext context) {
    Color color = reservation.status == ReservationStatus.LATE
        ? Colors.red[200]!
        : Colors.black;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      verticalDirection: VerticalDirection.down,
      children: [
        _buildReservationInfos(context),
        const SizedBox(height: 10),
        Text(
          "date-period".tr(namedArgs: {
            "startDate":
                DateFormat('d MMMM', 'FR').format(reservation.startDate),
            "endDate":
                DateFormat('d MMMM yyyy', 'FR').format(reservation.endDate)
          }),
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Text("nb-weeks"
            .tr(namedArgs: {"nbWeeks": reservation.nbWeeks.toString()})),
        Row(
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
        _buildGameDetails(context),
        const SizedBox(height: 20),
        _buildReservationSynthesis(context),
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
          children: [
            _buildTotalAmount(context),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: _buildDownloadInvoiceButton(context),
            ),
            _buildReturnedGameButton(context),
            _buildContactUser(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContactUser(BuildContext context) {
    return Row(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.email,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                // TODO
              },
            ),
            IconButton(
              icon: Icon(
                Icons.message,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: () {
                // TODO Firebase
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReturnedGameButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "returned-games".tr(),
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        Checkbox(
          checkColor: Theme.of(context).colorScheme.onPrimary,
          fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return Theme.of(context).colorScheme.secondary;
            }
            return Colors.white;
          }),
          value: reservation.returned,
          onChanged: (bool? value) {
            // TODO faire la modif en base
            setState(() {
              reservation.returned = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDownloadInvoiceButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // TODO : download invoice
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        "download-invoice".tr(),
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }

  Widget _buildTotalAmount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("${reservation.amount} €",
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
            const SizedBox(height: 10),
            Text("2%", // TODO faire le pourcentage en dynamique
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                )),
          ],
        ),
      ],
    );
  }

  Widget _buildGameDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListHeader(
          title: "details".tr(),
        ),
        const SizedBox(height: 10),
        _buildGameList(context),
      ],
    );
  }

  _buildGameList(BuildContext context) {
    return ListView.builder(
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
            child: GameTile(game: game));
      },
    );
  }

  Widget _buildReservationInfos(BuildContext context) {
    return Text(
      'reservation-details-title'.tr(namedArgs: {
        'number': reservation.reservationNumber.toString(),
        'firstname': reservation.user!.firstname,
        'lastname': reservation.user!.lastname
      }),
      style: Theme.of(context).textTheme.headline6,
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
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
    return null;
  }
}
