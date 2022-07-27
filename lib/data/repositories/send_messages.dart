import 'package:flutter/cupertino.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:provider/provider.dart';
import 'package:smsapp/data/providers/messages_provider.dart';
import 'package:smsapp/helpers/data_helper.dart';

import '../../helpers/shared_pref.dart';
import '../internet_connections/http_calls.dart';

class SendMessages {
  static void sendSmsMessages(
      BuildContext context, List<String> numbers) async {
    if (await numbers.isEmpty) {
      return;
    }

    Future.doWhile(() async {
      List messageData = await SharedPrefHelper.getList('${numbers.first}');
      String message = messageData[2];
      List<String> recipent = [messageData[0].toString()];
      bool result = await DataHelper.sendSms(message, recipent);
      if (result) {
        String? url = await SharedPrefHelper.getString('url');
        final response = await HttpConnections.getCall({
          'X_YEAR_ID': messageData[1],
          'X_SERIAL_ID': numbers.first.toString()
        }, '/UsoftSMSMobile/Usoft.asmx/SET_IS_SEND', urll: url.toString());
        try {
          SharedPrefHelper.removeKey('numbers');
          SharedPrefHelper.removeKey(numbers.first.toString());
          List<String> newNumbers = numbers;
          newNumbers.remove(numbers.first.toString());
          await SharedPrefHelper.saveList('numbers', newNumbers);
          Provider.of<MessagesProvider>(context, listen: false)
              .getMessagesFromSharedPref(newNumbers);
          if (newNumbers.isEmpty) {
            return false;
          }
        } catch (e) {
          print("there is a problem saving and taking data from sharedpref $e");
        }
      } else {
        return false;
      }
      return true;
    });
  }
}
