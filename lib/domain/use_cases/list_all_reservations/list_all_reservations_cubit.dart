import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/data/repositories/reservation/reservation_repository.dart';
import 'package:ludo_mobile/data/repositories/reservation/sorted_reservations.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:meta/meta.dart';

part 'list_all_reservations_state.dart';

@injectable
class ListAllReservationsCubit extends Cubit<ListAllReservationsState> {
  final SessionCubit _sessionCubit;
  final ReservationRepository _listReservationRepository;

  ListAllReservationsCubit(
    this._sessionCubit,
    this._listReservationRepository,
  ) : super(const ListAllReservationsInitial());

  void listReservations() async {
    emit(const ListAllReservationsLoading());
    SortedReservations reservations;
    try {
      reservations = await _listReservationRepository.getReservations();
    } catch (exception) {
      if (exception is UserNotLoggedInException ||
          exception is ForbiddenException) {
        _sessionCubit.logout();
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
      return;
    }

    emit(ListReservationsSuccess(reservations: reservations));
  }

  @override
  Future<void> close() {
    _sessionCubit.close();
    return super.close();
  }
}
