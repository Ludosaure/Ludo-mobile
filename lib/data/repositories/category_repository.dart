import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/data/providers/category_provider.dart';
import 'package:ludo_mobile/domain/models/game_category.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';

@injectable
class CategoryRepository {
  final CategoryProvider _categoryProvider;

  const CategoryRepository(this._categoryProvider);

  Future<List<GameCategory>> listCategories() async {
    final User? user = await LocalStorageHelper.getUserFromLocalStorage();

    if (user == null) {
      throw UserNotLoggedInException("errors.user-must-log-for-action".tr());
    }

    if(!user.isAdmin()) {
          throw NotAllowedException("errors.user-must-be-admin-for-action".tr());
    }

    final String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    return await _categoryProvider.listCategories(token!);
  }
}