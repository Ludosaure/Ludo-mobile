import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/data/repositories/reservation/reservation_repository.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:meta/meta.dart';

part 'list_all_reservations_state.dart';

@injectable
class ListAllReservationsCubit extends Cubit<ListAllReservationsState> {
  final ReservationRepository _listReservationRepository;

  ListAllReservationsCubit(this._listReservationRepository)
      : super(const ListAllReservationsInitial());

  void listReservations() async {
    emit(const ListAllReservationsLoading());

    try {
      final reservations = await _listReservationRepository.getReservations();
      emit(ListReservationsSuccess(reservations: reservations));
    } catch (exception) {

      if (
        exception is UserNotLoggedInException ||
        exception is ForbiddenException
      ) {
        emit(
          UserMustLogError(
            message: exception.toString(),
          ),
        );
        return;
      }

      emit(
        ListAllReservationsError(message: exception.toString()),
      );
    }
  }
}
