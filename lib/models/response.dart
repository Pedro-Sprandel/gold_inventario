class Response {
  bool success = false;
  String? message = "";
  dynamic data = [];

  Response({
    required this.success,
    this.message,
    this.data,
  });
}
