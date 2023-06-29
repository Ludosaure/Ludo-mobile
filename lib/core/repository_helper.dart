import 'package:easy_localization/easy_localization.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';

class RepositoryHelper {

  static Future<String?> getAdminToken() async {
    final User? user = await LocalStorageHelper.getUserFromLocalStorage();

    if(user == null) {
      throw UserNotLoggedInException('errors.user-must-log-for-action'.tr());
    }

    if(!user.isAdmin()) {
      throw NotAllowedException('errors.user-must-be-admin-for-action'.tr());
    }

    return LocalStorageHelper.getTokenFromLocalStorage();
  }
}