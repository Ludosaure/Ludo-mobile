import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

@injectable
class MediaProvider {
  final String _endpoint = '${AppConstants.API_URL}/media';

  Future<void> uploadPicture() async {

  }

  Future<void> deletePicture() async {

  }

}