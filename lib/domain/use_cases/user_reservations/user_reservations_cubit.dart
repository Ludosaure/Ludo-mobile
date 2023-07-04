import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/data/repositories/reservation/reservation_repository.dart';
import 'package:ludo_mobile/data/repositories/reservation/sorted_reservations.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:meta/meta.dart';

part 'user_reservations_state.dart';

@injectable
class UserReservationsCubit extends Cubit<UserReservationsState> {
  final SessionCubit _sessionCubit;
  final ReservationRepository _userReservationRepository;

  UserReservationsCubit(
    this._userReservationRepository,
    this._sessionCubit,
  ) : super(const UserReservationsInitial());

  void getMyReservations() async {
    emit(const UserReservationsLoading());

    try {
      final reservations = await _userReservationRepository.getMyReservations();
      emit(UserReservationsSuccess(reservations: reservations));
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
        _sessionCubit.logout();
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

  void returnReservationGames(String reservationId) {
    emit(const UserReservationsLoading());

    try {
      _userReservationRepository.returnReservationGames(reservationId);
      emit(const UserReservationsInitial());
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
        UserReservationsError(message: exception.toString()),
      );
    }
  }

  @override
  Future<void> close() {
    _sessionCubit.close();
    return super.close();
  }
}
