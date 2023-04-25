class AnonFilesUrl {
  AnonFilesUrl({
    required this.full,
    required this.short
  });

  String short;
  String full;

  factory AnonFilesUrl.fromJson(Map<String, dynamic> json) => AnonFilesUrl(
      full: json["full"],
      short: json["short"]
  );
}