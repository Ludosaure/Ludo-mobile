import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/data/repositories/reservation/reservation_repository.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:meta/meta.dart';

part 'user_reservations_state.dart';

@injectable
class UserReservationsCubit extends Cubit<UserReservationsState> {
  final ReservationRepository _userReservationRepository;

  UserReservationsCubit(this._userReservationRepository)
      : super(const UserReservationsInitial());

  void getMyReservations() async {
    emit(const UserReservationsLoading());

    try {
      final reservations = await _userReservationRepository.getMyReservations();
      emit(UserReservationsSuccess(reservations: reservations));
    } catch (exception) {
      if (exception is UserNotLoggedInException ||
          exception is ForbiddenException) {
        emit(
          UserMustLogError(
            message: exception.toString(),
          ),
        );

        return;
      }

      emit(
        UserReservationsError(message: exception.toString()),
      );
    }
  }

  void cancelReservation(String reservationId) {
    emit(const UserReservationsLoading());

    try {
      _userReservationRepository.cancelReservation(reservationId);
      emit(const UserReservationsInitial());
    } catch (exception) {
      if (exception is UserNotLoggedInException ||
          exception is ForbiddenException) {
        emit(
          UserMustLogError(
            message: exception.toString(),
          ),
        );
        return;
      }

      emit(
        UserReservationsError(message: exception.toString()),
      );
    }
  }
}
