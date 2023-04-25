import 'package:mobile_anonfiles/models/anonfiles_url.dart';

class AnonFilesFile {
  AnonFilesFile({
    required this.urls    
  });
  
  AnonFilesUrl urls;
  
  factory AnonFilesFile.fromJson(Map<String, dynamic> json) => AnonFilesFile(
      urls: AnonFilesUrl.fromJson(json["url"])
  );
}