import 'dart:convert';
import 'dart:io' as io;
import 'package:universal_html/html.dart' as html;

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/core/exception.dart';
import 'package:ludo_mobile/core/http_code.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

@injectable
class MediaProvider {
  final String _endpoint = '${AppConstants.API_URL}/media';

  Future<String> uploadPicture(String token, dynamic picture) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(_endpoint),
    );

    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    String? mimeType = "";

    if (kIsWeb) {
      html.File webPicture = picture as html.File;

      mimeType = lookupMimeType(webPicture.name)?.split('/').last;

      final reader = html.FileReader();
      reader.readAsArrayBuffer(webPicture);
      await reader.onLoad.first;
      final Uint8List bytes = reader.result as Uint8List;
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          bytes,
          filename: 'picture',
          contentType: MediaType('image', mimeType!),
        ),
      );

    } else {
      io.File mobilePicture = picture as io.File;
      mimeType = lookupMimeType(picture.path)?.split('/').last;
      request.files.add(
        http.MultipartFile(
          'file',
          mobilePicture.readAsBytes().asStream(),
          mobilePicture.lengthSync(),
          filename: 'picture',
          contentType: MediaType('image', mimeType!),
        ),
      );
    }

    final streamResponse = await request.send();

    final response = await http.Response.fromStream(streamResponse);

    if (streamResponse.statusCode == HttpCode.UNAUTHORIZED) {
      throw const UserNotLoggedInException("errors.user-must-log-for-action");
    }

    if (streamResponse.statusCode != HttpCode.CREATED) {
      throw Exception('errors.upload-picture-error');
    }

    return jsonDecode(response.body)["media"]["id"];
  }

  Future<void> deletePicture() async {}
}
