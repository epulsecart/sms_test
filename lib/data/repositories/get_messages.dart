import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smsapp/data/internet_connections/http_calls.dart';
import 'package:smsapp/data/models/user_data.dart';
import 'package:smsapp/data/providers/messages_provider.dart';
import 'package:smsapp/data/providers/user_provider.dart';
import 'package:smsapp/helpers/shared_pref.dart';

class GetMessagesRepo {
  static void getMessages(
      BuildContext context, Map<String, dynamic> user_data) async {
    try {
      final parameters = {
        'X_USER_NAME': user_data['X_USER_NAME'],
        'X_USER_PASS': user_data['X_USER_PASS'].toString(),
        'X_MOBILE_ID': user_data['X_MOBILE_ID'].toString()
      };
      final result = await HttpConnections.getCall(
          parameters, '/UsoftSMSMobile/Usoft.asmx/USMS_MESSAGES',
          context: context);
      print("have got this result ${result['decodedData']}");
      Provider.of<UserProvider>(context, listen: false)
          .saveUserData(UserData.fromJson(user_data));
      Provider.of<MessagesProvider>(context, listen: false)
          .getMessages(result['decodedData'], context);
      SharedPrefHelper.saveBool('exist', true);
    } catch (e) {
      print("in repo there is a problem $e");
    }
  }
}
