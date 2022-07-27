import 'package:flutter/cupertino.dart';

class ApiFunNames with ChangeNotifier {
  String url = 'unitedsoft.com.ye';
  void getUrl(String url) {
    this.url = '${url}';
    notifyListeners();
  }
}
