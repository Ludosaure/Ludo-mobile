part of 'download_invoice_cubit.dart';

@immutable
abstract class DownloadInvoiceState {
  const DownloadInvoiceState();
}

class DownloadInvoiceInitial extends DownloadInvoiceState {}

class DownloadInvoiceLoading extends DownloadInvoiceState {}

class DownloadInvoiceSuccess extends DownloadInvoiceState {
  final Response response;

  const DownloadInvoiceSuccess({required this.response});
}

class DownloadInvoiceError extends DownloadInvoiceState {
  final String message;

  const DownloadInvoiceError({required this.message});
}
