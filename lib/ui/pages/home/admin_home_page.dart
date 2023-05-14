import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:ludo_mobile/domain/use_cases/list_all_reservations/list_all_reservations_cubit.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/ui/pages/reservation/admin_reservation_list.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late List<Reservation> reservations;

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      body: Padding(
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
              return const Center(child: Text("Aucune réservation trouvées"));
            }

            if (state is ListReservationsSuccess) {
              reservations = state.reservations;

              return AdminReservationList(reservations: reservations);
            }

            if(state is UserMustLogError) {
              context.go(Routes.login.path);
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      navBarIndex: AdminMenuItems.Home.index,
      onSortPressed: null,
      onSearch: onSearch,
    );
  }

  void onSortPressed(String something) {
    //TODO faire un type abstrait pour les filtres
    setState(() {
      // reservations.sort((a, b) => a.date.compareTo(b.date));
    });
  }

  //TODO probablement passer par un cubit de ses morts
  void onSearch(String value) {
    setState(() {
      reservations = reservations
          .where((element) =>
              element.createdBy.firstname.contains(value) ||
              element.createdBy.lastname.contains(value) ||
              element.createdBy.email.contains(value))
          .toList();
    });
  }
}
