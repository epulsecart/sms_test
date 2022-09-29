import 'dart:async';

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
      if (numbers.length > 0) {
        List messageData = await SharedPrefHelper.getList('${numbers.first}');
        print("restart the dowhile ");

        ///
        print(
            "numbrs length now is ${Provider.of<MessagesProvider>(context, listen: false).numbers.length}");
        print(
            "messageData length now is ${Provider.of<MessagesProvider>(context, listen: false).messagesData.length}");
        if (Provider.of<MessagesProvider>(context, listen: false).sendSms) {
          String message = messageData[2];
          List<String> recipent = [messageData[0].toString()];
          bool result = false;
          await Future.delayed(
            Duration(
                seconds: Provider.of<MessagesProvider>(context, listen: false)
                            .sendSmsAfter >
                        0
                    ? Provider.of<MessagesProvider>(context, listen: false)
                        .sendSmsAfter
                    : 100),
            () async {
              print(
                  "will send the new message after ${Provider.of<MessagesProvider>(context, listen: false).sendSmsAfter}");
              try {
                result = await DataHelper.sendSms(message, recipent) as bool;
              } catch (e) {
                print("can not send sms $e");
              }
            },
          );

          if (result) {
            print("message $message sent to $recipent ");
            try {
              String? url = await SharedPrefHelper.getString('url');
              List tempList =
                  await SharedPrefHelper.getList(numbers.first.toString());
              String tempYearID = tempList[1].toString();
              final response = await HttpConnections.getCall({
                'X_SERIAL_ID': numbers.first.toString(),
                'X_YEAR_ID': tempYearID
              }, '/UsoftSMSMobile/Usoft.asmx/SET_IS_SEND',
                  urll: url.toString());

              SharedPrefHelper.removeKey('numbers');
              SharedPrefHelper.removeKey(numbers.first.toString());
              List<String> newNumbers = numbers;
              newNumbers.remove(numbers.first.toString());
              print("real numbrs elements are ${numbers}");

              print(
                  "will store ${newNumbers.length} to numbers in shared pref");
              await SharedPrefHelper.saveList('numbers', newNumbers);
              Provider.of<MessagesProvider>(context, listen: false)
                  .getMessagesFromSharedPref(newNumbers);
              if (newNumbers.isEmpty) {
                return false;
              }
            } catch (e) {
              print(
                  "there is a problem saving and taking data from sharedpref $e");
            }
          } else {
            return false;
          }
          return true;
        } else {
          print("stopping the proccess");
          return false;
        }
      } else
        return false;
    });
  }
}
