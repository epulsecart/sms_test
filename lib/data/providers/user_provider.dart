import 'package:flutter/cupertino.dart';
import 'package:smsapp/data/models/user_data.dart';
import 'package:smsapp/helpers/shared_pref.dart';

class UserProvider with ChangeNotifier {
  bool user_exist = false;
  UserData userData = UserData();

  void getUserData() async {
    userData.xUSERNAME = await SharedPrefHelper.getString('X_USER_NAME');
    userData.xMOBILEID =
        int.parse(await SharedPrefHelper.getString('X_MOBILE_ID').toString());
    userData.xUSERPASS =
        int.parse(await SharedPrefHelper.getString('X_USER_PASS').toString());
    userData.url = await SharedPrefHelper.getString('url');
    user_exist = true;
    notifyListeners();
  }

  void saveUserData(UserData ud) async {
    userData = ud;
    user_exist = true;
    notifyListeners();
  }
}
