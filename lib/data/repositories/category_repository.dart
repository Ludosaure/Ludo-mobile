import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/repository_helper.dart';
import 'package:ludo_mobile/data/providers/category_provider.dart';
import 'package:ludo_mobile/domain/models/game_category.dart';

@injectable
class CategoryRepository {
  final CategoryProvider _categoryProvider;

  const CategoryRepository(this._categoryProvider);

  Future<List<GameCategory>> listCategories() async {
    final String? token = await RepositoryHelper.getAdminToken();

    return await _categoryProvider.listCategories(token!);
  }
}