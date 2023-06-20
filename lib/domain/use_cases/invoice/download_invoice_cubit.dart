import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:universal_html/html.dart' as html;
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/repositories/invoice_repository.dart';
import 'package:meta/meta.dart';

part 'download_invoice_state.dart';

@injectable
class DownloadInvoiceCubit extends Cubit<DownloadInvoiceState> {
  final SessionCubit _sessionCubit;
  final InvoiceRepository _invoiceRepository;

  DownloadInvoiceCubit(
    this._sessionCubit,
    this._invoiceRepository,
  ) : super(DownloadInvoiceInitial());

  void downloadInvoice(String invoiceId, int invoiceNumber) async {
    emit(DownloadInvoiceLoading());
    String? filePath;
    final String filename = 'ludosaure-facture_$invoiceNumber.pdf';

    try {
      filePath = await _invoiceRepository.downloadInvoice(invoiceId, filename);
    } catch (exception) {
      if(exception is UserNotLoggedInException) {
        _sessionCubit.logout();
        emit(UserMustLog());
        return;
      }

      emit(
        DownloadInvoiceError(message: exception.toString()),
      );
      return;
    }

    if (kIsWeb) {
      html.AnchorElement downloadLink = html.AnchorElement()
        ..href = filePath
        ..download = filename;
      html.document.body?.append(downloadLink);
      downloadLink.click();
      downloadLink.remove();
    }

    emit(
      DownloadInvoiceSuccess(file: filePath),
    );
  }

  @override
  Future<void> close() {
    _sessionCubit.close();
    return super.close();
  }
}
