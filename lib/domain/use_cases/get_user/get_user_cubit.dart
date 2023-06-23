import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/repositories/user_repository.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:meta/meta.dart';

part 'get_user_state.dart';

@injectable
class GetUserCubit extends Cubit<GetUserState> {
  final UserRepository _userRepository;

  GetUserCubit(
    this._userRepository,
  ) : super(GetUserInitial());

  void getUser() async {
    emit(GetUserLoading());
    try {
      final User user = await _userRepository.getMyInfos();
      emit(GetUserSuccess(user: user));
    } catch (exception) {
      emit(
        GetUserError(message: exception.toString()),
      );
    }
  }

  dispose() {
    super.close();
  }
}
