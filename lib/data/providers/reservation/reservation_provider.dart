import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/data/repositories/reservation/new_reservation.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

import 'package:http/http.dart' as http;
import 'package:ludo_mobile/utils/local_storage_helper.dart';

@injectable
class ReservationProvider {
  final String endpoint = '${AppConstants.API_URL}/reservation';

  Future<List<Reservation>> getReservations() async {
    String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    if (token == null) {
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
      if (error is SocketException) {
        throw ServiceUnavailableException('errors.service-unavailable'.tr());
      }
      throw InternalServerException('errors.unknown'.tr());
    });

    if (response.statusCode == HttpCode.UNAUTHORIZED) {
      await LocalStorageHelper.removeUserFromLocalStorage();

      throw ForbiddenException('errors.forbidden-access'.tr());
    } else if (response.statusCode != HttpCode.OK) {
      throw InternalServerException('errors.unknown'.tr());
    }

    List<Reservation> reservations = [];
    jsonDecode(response.body)["reservations"].forEach((reservation) {
      reservations.add(Reservation.fromJson(reservation));
    });

    return reservations;
  }

  Future<String> createReservation(NewReservation reservation) async {
    String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    if (token == null) {
      throw UserNotLoggedInException("errors.user-must-log-for-access".tr());
    }

    http.Response response = await http
        .post(
      Uri.parse(endpoint),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(reservation.toJson()),
    )
        .catchError((error) {
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

    return response.body;
  }

  Future<void> confirmReservationPayment(NewReservation reservation) async {
    String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    if (token == null) {
      throw UserNotLoggedInException("errors.user-must-log-for-access".tr());
    }

    http.Response response = await http
        .put(
      Uri.parse("$endpoint/pay"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'reservationId': reservation.id,
      }),
    )
        .catchError((error) {
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
  }

  Future<List<Reservation>> listUserReservations({String? userId}) async {
    String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    if (token == null) {
      throw UserNotLoggedInException("errors.user-must-log-for-access".tr());
    }

    User? user = await LocalStorageHelper.getUserFromLocalStorage();

    if (user == null) {
      throw UserNotLoggedInException("errors.user-must-log-for-access".tr());
    }

    userId ??= user.id;

    final http.Response response = await http.get(
      Uri.parse("$endpoint/userId/$userId"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).catchError((error) {
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

    List<Reservation> reservations = [];
    jsonDecode(response.body)["reservations"].forEach((reservation) {
      reservations.add(
        Reservation.fromJsonAndUser(reservation, user),
      );
    });

    return reservations;
  }

  Future<void> cancelReservation(String reservationId) async {
    String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    if (token == null) {
      throw UserNotLoggedInException("errors.user-must-log-for-access".tr());
    }

    late http.Response response;
    response = await http
        .put(
      Uri.parse("$endpoint/cancel"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'reservationId': reservationId,
      }),
    )
        .catchError((error) {
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
  }

  Future<void> returnReservationGames(String reservationId) async {
    String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    if (token == null) {
      throw UserNotLoggedInException("errors.user-must-log-for-access".tr());
    }

    late http.Response response;
    response = await http
        .put(
      Uri.parse("$endpoint/return"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'id': reservationId,
      }),
    )
        .catchError((error) {
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
  }

  Future<void> removeUnpaidReservation(String reservationId) async {
    String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    if (token == null) {
      throw UserNotLoggedInException("errors.user-must-log-for-access".tr());
    }

    late http.Response response;
    response = await http
        .delete(
      Uri.parse("$endpoint/$reservationId"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    )
        .catchError((error) {
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
  }

  Future<Reservation> getReservation(String reservationId) async {
    String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    if(token == null) {
      throw UserNotLoggedInException("errors.user-must-log-for-access".tr());
    }

    late http.Response response;

    response = await http.get(
      Uri.parse("$endpoint/id/$reservationId"),
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

    return Reservation.fromJson(jsonDecode(response.body)["reservation"]);
  }
}
