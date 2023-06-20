import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/repositories/category_repository.dart';
import 'package:ludo_mobile/domain/models/game_category.dart';
import 'package:meta/meta.dart';

part 'get_categories_state.dart';

@injectable
class GetCategoriesCubit extends Cubit<GetCategoriesState> {
  final CategoryRepository _categoryRepository;

  GetCategoriesCubit(
    this._categoryRepository,
  ) : super(GetCategoriesInitial());

  Future<void> getCategories() async {
    emit(GetCategoriesLoading());

    try {
      final categories = await _categoryRepository.listCategories();
      emit(GetCategoriesSuccess(categories: categories));
    } catch (e) {
      emit(
        GetCategoriesError(message: e.toString()),
      );
    }
  }
}
