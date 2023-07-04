import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:ludo_mobile/domain/use_cases/user_reservations/user_reservations_cubit.dart';
import 'package:ludo_mobile/ui/pages/reservation/reservation_list.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class UserReservationsPage extends StatefulWidget {
  const UserReservationsPage({super.key});

  @override
  State<UserReservationsPage> createState() => _UserReservationsPageState();
}

class _UserReservationsPageState extends State<UserReservationsPage> {
  late List<Reservation> reservations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('my-reservations-title').tr(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        )
      ),
      body: _buildReservationList(),
    );
  }

  Widget _buildReservationList() {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<UserReservationsCubit>(context).getMyReservations();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: BlocConsumer<UserReservationsCubit, UserReservationsState>(
          listener: (context, state) {
            if (state is UserReservationsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
            if (state is UserMustLogError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is UserReservationsInitial) {
              BlocProvider.of<UserReservationsCubit>(context)
                  .getMyReservations();
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is UserReservationsError) {
              return Center(
                child: const Text("no-reservation-found").tr(),
              );
            }

            if (state is UserReservationsSuccess) {
              reservations = state.reservations;

              return ReservationList(reservations: reservations);
            }

            if (state is UserMustLogError) {
              context.go(Routes.login.path);
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

}
