import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:meta/meta.dart';

part 'get_game_state.dart';

@injectable
class GetGameCubit extends Cubit<GetGameState> {
  final SessionCubit _sessionCubit;

  GetGameCubit( this._sessionCubit) : super(GetGameInitial());

  // void getGame() async {
  //   emit(GetGameLoading());
  //   try {
  //     emit(GetGameSuccess());
  //   } catch (exception) {
  //     emit(
  //       GetGameError(message: exception.toString()),
  //     );
  //   }
  // }

  dispose() {
    _sessionCubit.close();
    super.close();
  }
}
