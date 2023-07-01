import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/data/providers/review_provider.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';

@injectable
class ReviewRepository {
  final ReviewProvider _reviewProvider;

  ReviewRepository(this._reviewProvider);

  Future<void> reviewGame(String gameId, int rating, String? comment) async {
    final String? userToken =
        await LocalStorageHelper.getTokenFromLocalStorage();
    if (userToken == null) {
      throw UserNotLoggedInException('errors.user-must-log-for-action'.tr());
    }

    await _reviewProvider.reviewGame(
      gameId,
      rating,
      comment,
      userToken,
    );
  }
}
