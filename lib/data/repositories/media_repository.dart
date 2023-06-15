import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/data/providers/media_provider.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';

@injectable
class MediaRepository {
  final MediaProvider _mediaProvider;

  MediaRepository(this._mediaProvider);

  Future<String> uploadPicture(File picture) async {
    String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    if(token == null) {
      throw const UserNotLoggedInException('errors.user-must-log-for-action');
    }

    return await _mediaProvider.uploadPicture(token, picture);
  }

  Future<void> deletePicture() async {
    return await _mediaProvider.deletePicture();
  }

}