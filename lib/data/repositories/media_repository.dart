import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/media_provider.dart';

@injectable
class MediaRepository {
  final MediaProvider _mediaProvider;

  MediaRepository(this._mediaProvider);

  Future<void> uploadPicture() async {
    return await _mediaProvider.uploadPicture();
  }

  Future<void> deletePicture() async {
    return await _mediaProvider.deletePicture();
  }

}