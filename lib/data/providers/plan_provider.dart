import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/domain/models/plan.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';
import 'package:http/http.dart' as http;

@injectable
class PlanProvider {
  final String endpoint = '${AppConstants.API_URL}/plan';

  Future<List<Plan>> listPlans() async {
    final String? userToken =
        await LocalStorageHelper.getTokenFromLocalStorage();

    if (userToken == null) {
      throw UserNotLoggedInException('errors.user-must-log-for-action'.tr());
    }

    final response = await http.get(Uri.parse(endpoint), headers: {
      'Authorization': 'Bearer $userToken',
      'Content-Type': 'application/json',
    }).catchError((error) {
      if (error is SocketException) {
        throw ServiceUnavailableException('errors.service-unavailable'.tr());
      }

      throw InternalServerException('errors.unknown'.tr());
    });

    if (response.statusCode == HttpCode.UNAUTHORIZED) {
      throw ForbiddenException('errors.forbidden-access'.tr());
    } else if (response.statusCode != HttpCode.OK) {
      throw InternalServerException('errors.unknown'.tr());
    }

    List<Plan> plans = [];
    jsonDecode(response.body)["plans"].forEach((plan) {
      plans.add(Plan.fromJson(plan));
    });

    return plans;
  }
}
