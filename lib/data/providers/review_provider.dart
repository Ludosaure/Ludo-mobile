import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/core/http_helper.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:http/http.dart' as http;

@injectable
class ReviewProvider {
  final String endpoint = '${AppConstants.API_URL}/review';

  Future<void> reviewGame(
    String gameId,
    int rating,
    String? comment,
    String userToken,
  ) async {
    final response = await http.post(
      Uri.parse(endpoint),
      headers: HttpHelper.getHeaders(userToken),
      body: jsonEncode({
        'gameId': gameId,
        'rating': rating,
        'comment': comment,
      }),
    ).catchError((error) {
      HttpHelper.handleRequestException(error);
    });

    if(response.statusCode != HttpCode.CREATED) {
      throw Exception("Erreur lors de l'enregistrement du commentaire");
    }

  }
}
