import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/data/repositories/reservation/sorted_reservations.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/user_reservations/user_reservations_cubit.dart';
import 'package:ludo_mobile/ui/pages/reservation/reservation_list.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class UserReservationsPage extends StatefulWidget {
  final User connectedUser;

  const UserReservationsPage({
    super.key,
    required this.connectedUser,
  });

  @override
  State<UserReservationsPage> createState() => _UserReservationsPageState();
}

class _UserReservationsPageState extends State<UserReservationsPage> {
  late SortedReservations reservations;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey[50],
        shadowColor: Colors.grey[100],
        title: const Text(
          'my-reservations-title',
          style: TextStyle(color: Colors.black),
        ).tr(),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            if(Navigator.canPop(context)) {
              context.pop();
            }
            else {
              context.go(Routes.home.path);
            }
          },
        ),
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

            return ReservationList(
              connectedUser: widget.connectedUser,
              reservations: reservations,
            );
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
