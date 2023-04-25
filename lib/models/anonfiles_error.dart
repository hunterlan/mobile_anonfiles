class AnonFilesError {
  AnonFilesError({
    required this.message,
    required this.type,
    required this.code
  });

  String message;
  String type;
  int code;

  factory AnonFilesError.fromJson(Map<String, dynamic> json) => AnonFilesError(
      message: json["message"],
      type: json["type"],
      code: json["code"]
  );
}