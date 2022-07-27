
class ApiHelper {
  /// user helper
  static Map<String, String>? getHeader(String? token) {
    Map<String, String>? header = {
      "Content-Type": "application/json",
      "Accept": "*/*",
      "Authorization": "Bearer $token"
    };
    return header;
  }

  static Map<String, String>? noUserHeader() {
    Map<String, String>? header = {
      "Content-Type": "application/json",
      "Accept": "*/*",
    };
    return header;
  }
}
