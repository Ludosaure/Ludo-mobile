import 'dart:convert';
import 'dart:io';

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
      throw const UserNotLoggedInException("Veuillez vous connecter pour accéder à cette page");
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
        throw const ServiceUnavailableException('Service indisponible. Veuillez réessayer ultérieurement');
      }
      throw const InternalServerException('Erreur inconnue');
    });

    if(response.statusCode == HttpCode.UNAUTHORIZED) {
      throw const ForbiddenException("Vous n'avez pas accès à cette page");
    } else if(response.statusCode != HttpCode.OK) {
      throw const InternalServerException('Erreur inconnue');
    }

    List<Reservation> reservations = [];
    jsonDecode(response.body)["reservations"].forEach((reservation) {
      reservations.add(Reservation.fromJson(reservation));
    });

    return reservations;
  }
}