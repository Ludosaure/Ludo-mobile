import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:ludo_mobile/core/exception.dart';

class HttpHelper {
  static Map<String, String> getHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
  
  static handleRequestException(dynamic error) {
    if (error is SocketException) {
      throw ServiceUnavailableException(
        'errors.service-unavailable'.tr(),
      );
    }

    throw InternalServerException("${'errors.unknown'.tr()} $error");
  }
}