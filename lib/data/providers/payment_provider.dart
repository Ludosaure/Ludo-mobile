import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/core/http_helper.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:ludo_mobile/utils/local_storage_helper.dart';

@injectable
class PaymentProvider {
  final String endpoint = '${AppConstants.API_URL}/stripe';

  Future<CreatePaymentIntentResponse> createPaymentIntent(double amount) async {
    final String? userToken =
        await LocalStorageHelper.getTokenFromLocalStorage();
    if (userToken == null) {
      throw UserNotLoggedInException('errors.user-must-log-for-action'.tr());
    }

    final int amountInCents = (amount * 100).toInt();

    final response = await http.post(
      Uri.parse('$endpoint/charge'),
      headers: HttpHelper.getHeaders(userToken),
      body: jsonEncode({
        'amount': amountInCents,
        'paymentMethodId': AppConstants.STRIPE_PAYMENT_ID,
      }),
    ).catchError((error) {
      HttpHelper.handleRequestException(error);
    });

    if (response.statusCode != HttpCode.CREATED) {
      throw Exception('Erreur lors de la création du paiement');
    }

    final paymentIntent = jsonDecode(response.body);

    return CreatePaymentIntentResponse.fromJson(paymentIntent);
  }
}

class CreatePaymentIntentResponse {
  final String clientSecret;
  final String customerId;

  CreatePaymentIntentResponse({
    required this.clientSecret,
    required this.customerId,
  });

  factory CreatePaymentIntentResponse.fromJson(Map<String, dynamic> json) {
    return CreatePaymentIntentResponse(
      clientSecret: json['client_secret'],
      customerId: json['id'],
    );
  }
}
