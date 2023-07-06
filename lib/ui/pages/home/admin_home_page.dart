import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/data/repositories/reservation/sorted_reservations.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/list_all_reservations/list_all_reservations_cubit.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/ui/pages/reservation/reservation_list.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class AdminHomePage extends StatefulWidget {
  final User user;

  const AdminHomePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late SortedReservations reservations;

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      body: _buildReservationList(),
      navBarIndex: AdminMenuItems.Home.index,
      onSortPressed: null,
      onSearch: null,
      user: widget.user,
    );
  }

  Widget _buildReservationList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: BlocConsumer<ListAllReservationsCubit, ListAllReservationsState>(
        listener: (context, state) {
          if (state is ListAllReservationsError) {
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
          if (state is ListAllReservationsInitial) {
            BlocProvider.of<ListAllReservationsCubit>(context)
                .listReservations();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ListAllReservationsError) {
            return Center(
              child: const Text("no-reservation-found").tr(),
            );
          }

          if (state is ListReservationsSuccess) {
            reservations = state.reservations;

            return ReservationList(
              connectedUser: widget.user,
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
    );
  }
}
