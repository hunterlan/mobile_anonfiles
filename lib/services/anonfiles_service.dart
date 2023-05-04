import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/anonfiles_response.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

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

  Future<bool> download(String url) async {
    String htmlPage = '';

    // NOTICE: If on some step something went wrong, return false

    // STEP 1: Download whole HTML page

    var response = await http.get(Uri.parse(url));
    //If the http request is successful the statusCode will be 200
    if (response.statusCode == 200) {
      htmlPage = response.body;
    } else {
      return false;
    }
    // STEP 2: Scrap it to find a button with real link
    final document = parser.parse(htmlPage);
    final downloadLinkElement = document.getElementById('download-url');
    if (downloadLinkElement == null) {
      return false;
    }
    final downloadUrl = downloadLinkElement.attributes['href'];
    if (downloadUrl == null) {
      return false;
    }

    // STEP 3: Request path to where save a file
    String dir = '';
    if (Platform.isIOS) {
      var iosDir = await getApplicationDocumentsDirectory();
      dir = iosDir.path;
    } else {
      dir = '/storage/emulated/0/Download/';
    }

    if (dir.isEmpty) return false;

    // STEP 4: Download via DIO file
    try {
      Response response = await Dio().get(
        downloadUrl,
        options: Options(
          responseType: ResponseType.bytes
        )
      );
      String filename = response.headers.value("content-disposition")!.split('=').last.replaceAll("\"", "");
      File file = File(dir + filename);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    }
    catch (e) {
      return false;
    }

    return true;
  }
}