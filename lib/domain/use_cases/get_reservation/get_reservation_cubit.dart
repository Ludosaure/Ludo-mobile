import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/repositories/reservation/reservation_repository.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:meta/meta.dart';

part 'get_reservation_state.dart';

@injectable
class GetReservationCubit extends Cubit<GetReservationState> {
  final ReservationRepository _reservationRepository;

  GetReservationCubit(
    this._reservationRepository,
  ) : super(GetReservationInitial());

  void getReservation(String reservationId) async {
    emit(GetReservationLoading());
    try {
      final Reservation reservation = await _reservationRepository.getReservation(reservationId);
      emit(GetReservationSuccess(reservation: reservation));
    } catch (exception) {
      emit(
        GetReservationError(message: exception.toString()),
      );
    }
  }

  dispose() {
    super.close();
  }
}
