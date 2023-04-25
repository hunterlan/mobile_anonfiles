import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../models/anonfiles_response.dart';
import 'package:http/http.dart' as http;

class AnonFilesService {
  final _url = 'https://api.anonfiles.com';

  Future<List<AnonFilesResponse>> upload(List<PlatformFile> files) async {
    List<AnonFilesResponse> responses = List.empty(growable: true);

    for (var pickedFile in files) {
      File file = File(pickedFile.path!);
      var fileName = file.path.split('/').last;
      var mimeType = lookupMimeType(fileName)!.split('/');

      var formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName, contentType: MediaType(mimeType[0], mimeType[1]))
      }, ListFormat.multi, true);

      dynamic response;

      try {
        response = await Dio().post('$_url/upload', options: Options(
              responseType: ResponseType.plain,
              contentType: 'multipart/form-data'
            ),
            data: formData);
      }
      on DioError catch (ex) {
        response = ex.response;
      }

      responses.add(AnonFilesResponse.fromJson(jsonDecode(response.data.toString()), file));
    }

    return responses;
  }
}