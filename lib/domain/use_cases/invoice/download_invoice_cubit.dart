import 'package:bloc/bloc.dart';
import 'package:http/http.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/repositories/invoice_repository.dart';
import 'package:meta/meta.dart';

part 'download_invoice_state.dart';

@injectable
class DownloadInvoiceCubit extends Cubit<DownloadInvoiceState> {
  final InvoiceRepository _invoiceRepository;

  DownloadInvoiceCubit(
    this._invoiceRepository,
  ) : super(DownloadInvoiceInitial());

  void downloadInvoice(String invoiceId) async {
    emit(DownloadInvoiceLoading());
    try {
      final Response response = await _invoiceRepository.downloadInvoice(invoiceId);
      emit(DownloadInvoiceSuccess(response : response));
    } catch (exception) {
      emit(
        DownloadInvoiceError(message: exception.toString()),
      );
    }
  }

  dispose() {
    super.close();
  }
}
