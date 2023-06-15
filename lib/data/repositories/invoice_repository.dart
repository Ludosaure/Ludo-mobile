import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/invoice/invoice_provider.dart';

@injectable
class InvoiceRepository {
  final InvoiceProvider _invoiceProvider;

  InvoiceRepository(this._invoiceProvider);

  Future<Response> downloadInvoice(String invoiceId) async {
    return await _invoiceProvider.downloadInvoice(invoiceId);
  }

}