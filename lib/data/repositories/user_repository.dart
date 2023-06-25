import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/data/providers/user/update_user_request.dart';
import 'package:ludo_mobile/data/providers/user/user_provider.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';

@injectable
class UserRepository {
  final UserProvider _userProvider;

  UserRepository(this._userProvider);

  Future<User> getMyInfos() async {
    final User? user = await LocalStorageHelper.getUserFromLocalStorage();

    if(user == null) {
      throw UserNotLoggedInException('errors.user-must-log-for-action'.tr());
    }

    final String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    return await _userProvider.getMyInfos(token!);
  }

  Future<User> updateUser(UpdateUserRequest updateUserRequest) async {
    final User? user = await LocalStorageHelper.getUserFromLocalStorage();

    if(user == null) {
      throw UserNotLoggedInException('errors.user-must-log-for-action'.tr());
    }

    final String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    return await _userProvider.updateUser(token!, updateUserRequest);
  }

}