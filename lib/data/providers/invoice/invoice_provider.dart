import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/core/http_helper.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:ludo_mobile/utils/local_storage_helper.dart';

@injectable
class InvoiceProvider {
  final String baseUrl = '${AppConstants.API_URL}/invoice';

  Future<String> downloadInvoice(String invoiceId) async {
    String? token = await LocalStorageHelper.getTokenFromLocalStorage();

    if (token == null) {
      throw UserNotLoggedInException("errors.user-must-log-for-access".tr());
    }

    final http.Response response = await http.post(
      Uri.parse("$baseUrl/generate/$invoiceId"),
      headers: HttpHelper.getHeaders(token),
    ).catchError((error) {
      HttpHelper.handleRequestException(error);
    });

    if (response.statusCode == HttpCode.NOT_FOUND) {
      throw NotFoundException(
        "errors.invoice-not-found".tr(),
      );
    }

    if (response.statusCode != HttpCode.CREATED) {
      throw InternalServerException(
        "errors.unknown".tr(),
      );
    }

    return response.body;
  }
}
