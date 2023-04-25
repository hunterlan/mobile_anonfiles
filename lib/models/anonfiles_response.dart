import 'dart:io';

import 'package:mobile_anonfiles/models/anonfiles_error.dart';
import 'package:mobile_anonfiles/models/anonfiles_file.dart';

class AnonFilesResponse {
  AnonFilesResponse({
    required this.status,
    required this.file,
    this.data,
    this.error
  });

  File file;
  bool status;
  AnonFilesFile? data;
  AnonFilesError? error;

  factory AnonFilesResponse.fromJson(Map<String, dynamic> json, File currentFile) => AnonFilesResponse(
      status: json["status"],
      data: json["status"] == true ? AnonFilesFile.fromJson(json["data"]["file"]) : null,
      error: json["status"] == false ? AnonFilesError.fromJson(json["error"]) : null,
      file: currentFile
  );
}