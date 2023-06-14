import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/repositories/game_repository.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/use_cases/list_reduction_plan/list_reduction_plan_cubit.dart';
import 'package:meta/meta.dart';

part 'get_games_state.dart';

@injectable
class GetGamesCubit extends Cubit<GetGamesState> {
  final ListReductionPlanCubit _listReductionPlanCubit;
  final GameRepository _getGamesRepository;

  GetGamesCubit(
    this._getGamesRepository,
    this._listReductionPlanCubit,
  ) : super(const GetGamesInitial());

  void getGames() async {
    emit(const GetGamesLoading());
    try {
      final games = await _getGamesRepository.getGames();
      await _listReductionPlanCubit.listReductionPlan();
      emit(GetGamesSuccess(games: games));
    } catch (e) {
      emit(
        GetGamesError(message: e.toString()),
      );
    }
  }

  dispose() {
    _listReductionPlanCubit.close();
    super.close();
  }
}
