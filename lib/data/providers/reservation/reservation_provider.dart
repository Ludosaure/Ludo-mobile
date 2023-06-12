import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

import 'package:http/http.dart' as http;
import 'package:ludo_mobile/utils/local_storage_helper.dart';

@injectable
class ReservationProvider {
  final String endpoint = '${AppConstants.API_URL}/reservation';

  Future<List<Reservation>> getReservations() async {
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

    List<Reservation> reservations = [];
    jsonDecode(response.body)["reservations"].forEach((reservation) {
      reservations.add(Reservation.fromJson(reservation));
    });

    return reservations;
  }
}