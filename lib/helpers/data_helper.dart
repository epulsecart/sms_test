import 'package:flutter_sms/flutter_sms.dart';
import 'package:smsapp/helpers/shared_pref.dart';

class DataHelper {
  static Future sendSms(message, List<String> recipents) async {
    String result = 'SMS Sent!';
    await sendSMS(message: message, recipients: recipents, sendDirect: true)
        .catchError((error) {});
    if (result == 'SMS Sent!') {
      return true;
    } else {
      return false;
    }
  }

  static Future getMessageData(String number) async {
    return await SharedPrefHelper.getList(number);
  }

  static Future getMessagesList() async {
    return await SharedPrefHelper.getList('numbers');
  }
}
