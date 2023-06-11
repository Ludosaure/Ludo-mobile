import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/domain/models/conversation.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';

@injectable
class MessageProvider {
  final String endpoint = '${AppConstants.API_URL}/message';

  Future<List<Conversation>> getMyConversations() async {
    String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    if(token == null) {
      throw UserNotLoggedInException("errors.user-must-log-for-access".tr());
    }

    late http.Response response;

    response = await http.get(
        Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).catchError((error) {
      if(error is SocketException) {
        throw ServiceUnavailableException('errors.service-unavailable'.tr());
      }
      throw InternalServerException('errors.unknown'.tr());
    });

    if(response.statusCode == HttpCode.UNAUTHORIZED) {
      throw ForbiddenException('errors.forbidden-access'.tr());
    } else if(response.statusCode != HttpCode.OK) {
      throw InternalServerException('errors.unknown'.tr());
    }

    List<Conversation> conversations = [];
    jsonDecode(response.body)["conversations"].forEach((reservation) {
      conversations.add(Conversation.fromJson(reservation));
    });

    return conversations;
  }
}