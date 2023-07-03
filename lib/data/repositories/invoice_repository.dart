import 'dart:convert';
import 'package:universal_html/html.dart' as html;
import 'dart:io' as io show File;

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/data/providers/invoice/invoice_provider.dart';
import 'package:permission_handler/permission_handler.dart';

@injectable
class InvoiceRepository {
  final InvoiceProvider _invoiceProvider;

  InvoiceRepository(this._invoiceProvider);

  Future<String> downloadInvoice(String invoiceId, String filename) async {
    final base64File = await _invoiceProvider.downloadInvoice(invoiceId);

    if (!kIsWeb) {
      return await _createFileFromString(jsonDecode(base64File), filename);
    }

    return _getFileUrl(jsonDecode(base64File));
  }

  Future<String> _getFileUrl(String base64File) async {
    List<int> bytes = base64Decode(base64File);
    html.Blob blob = html.Blob([bytes]);

    return html.Url.createObjectUrlFromBlob(blob);
  }

  Future<String> _createFileFromString(
    String base64File,
    String filename,
  ) async {
    String? dir = await _findLocalPath();

    var status = await Permission.storage.request();
    if (status.isDenied) {
      dir = '/storage/emulated/0/Android/data/';
    }

    io.File file = io.File("$dir/$filename");
    Uint8List fileAsBytes = base64.decode(base64File);

    await file.writeAsBytes(fileAsBytes);

    return file.path;
  }

  Future<String?> _findLocalPath() async {
    return "/sdcard/download";
  }
}
