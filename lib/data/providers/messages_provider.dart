
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:smsapp/data/models/messages.dart';
import 'package:smsapp/data/repositories/send_messages.dart';
import 'package:smsapp/helpers/shared_pref.dart';

import '../../helpers/data_helper.dart';
import '../internet_connections/http_calls.dart';

class MessagesProvider with ChangeNotifier {
  bool recievedData = false;
  bool sendSms = false;
  int sendSmsAfter = 3;
  List<Map<String, dynamic>> messagesData = [];
  List<String> numbers = [];

  // void getMessages2(List messagesList, BuildContext context ) async {
  //   if (messagesList.isEmpty  ) {
  //     print("messages from server are numm so exiting now");
  //     return;
  //   }
  //   messagesData = [];
  //   numbers = [];
  //   List<String> temp = [];
  //   try {
  //     temp = await SharedPrefHelper.getList('numbers');
  //   } catch (e) {
  //     print("there are no numbers in sql light");
  //   }
  //   await Future.forEach(messagesList, (ele) async {
  //     Map element = ele as Map;
  //
  //     if (element['SERIAL_ID'].toString().isNotEmpty && !await SharedPrefHelper.checkKey(element['SERIAL_ID'].toString())) {
  //       print("this ${element['SERIAL_ID']} is not in light sql");
  //       if (element['MOBILE_NO'] != '' &&
  //           element['MOBILE_NO'].toString().length >= 9 &&
  //           element['YEAR_ID'] != '' &&
  //           element['SERIAL_ID'] != '' &&
  //           element['SHURT_MESSAGE'] != '') {
  //         List<String> currentMessage = [
  //           element['MOBILE_NO'].toString(),
  //           element['YEAR_ID'].toString(),
  //           element['SHURT_MESSAGE'].toString(),
  //         ];
  //         print("will save ${element['SERIAL_ID']} to SQLLight");
  //         SharedPrefHelper.saveList(
  //             element['SERIAL_ID'].toString(), currentMessage);
  //         numbers.add(element['SERIAL_ID'].toString());
  //         print("there is ${numbers.length} new elements");
  //       }
  //     } else {
  //       // print('this element ${element['SERIAL_ID']} exist in sql light');
  //       // if (!temp.contains(element['SERIAL_ID'])) {
  //       //   temp.add(element['SERIAL_ID']);
  //       // }
  //     }
  //   });
  //
  //   print("there was ${temp.length} elements in the sql Light");
  //   if (temp.isNotEmpty) {
  //     // temp.addAll(numbers);
  //     // print("now there are ${temp.length} elements ");
  //     // print("now temp.first ${temp.first} elements ");
  //     // SharedPrefHelper.saveList('numbers', temp);
  //   } else {
  //     SharedPrefHelper.saveList('numbers', numbers);
  //     print('because sql light was empty we will add only ${numbers.length}');
  //   }
  //   print("now we will call messages from sql light");
  //   // getMessagesFromSharedPref(await SharedPrefHelper.getList('numbers'));
  //   recievedData = true;
  //   if (Provider.of<MessagesProvider>(context, listen: false).sendSms) {
  //     SendMessages.sendSmsMessages(
  //         context, await SharedPrefHelper.getList('numbers'));
  //   }
  //   if (temp.isNotEmpty) {
  //     recievedData = true;
  //   } else {
  //     recievedData = false;
  //   }
  //
  //   notifyListeners();
  // }


  void getMessages(List messagesList) {
    if (messagesList.isEmpty  ) {
      print("messages from server are numm so exiting now");
      return;
    }
    print("got messages to the provider ${messagesList.length}");
    for (Map<String, dynamic> message in messagesList){
      if(message['SERIAL_ID'].toString().isEmpty || numbers.contains(message['SERIAL_ID'])){
      }else {
        messagesData.add(message);
        numbers.add(message['SERIAL_ID']);
      }
    }
    if (sendSms){
      sendSmsMessage();
    }
    recievedData = true;
    notifyListeners();
  }


  // Future getMessagesFromSharedPref(List<String> numbers) async {
  //   print("there are ${numbers.length} messages");
  //   if (numbers.isEmpty) {
  //     recievedData = false;
  //     notifyListeners();
  //     return;
  //   }
  //   try {
  //     messagesData = [];
  //     this.numbers = [];
  //     this.numbers = numbers;
  //     await Future.forEach(numbers, (element) async {
  //       List data = await SharedPrefHelper.getList(element.toString());
  //       Map<String, dynamic> messageData = {element.toString(): data};
  //       this.messagesData.add(messageData);
  //     });
  //     if (messagesData.isNotEmpty ||
  //         this.numbers.isNotEmpty &&
  //             messagesData.length == this.numbers.length) {
  //       recievedData = true;
  //     } else {
  //       recievedData = false;
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     print(
  //         "hi there is a problem in getting the data from shared pref in message_provider $e");
  //   }
  // }


  void sendSmsMessage ()async{
    if (messagesData.isEmpty) return ;
    List<Map<String, dynamic>> tempMessageData =messagesData;
    for(Map<String, dynamic> messag in tempMessageData){
      if (messag['sent']==null || !messag['sent']){
        messag['sent'] = true;
        notifyListeners();
        String message = messag['SHURT_MESSAGE'];
        List<String> recipent = [messag['MOBILE_NO'].toString()];
        bool result = true;
        await Future.delayed(
          Duration(seconds: sendSmsAfter > 0?sendSmsAfter: 100),
              () async {
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

            final response = await HttpConnections.getCall({
              'X_SERIAL_ID': messag['SERIAL_ID'],
              'X_YEAR_ID': messag['YEAR_ID']
            }, '/UsoftSMSMobile/Usoft.asmx/SET_IS_SEND',
                urll: url.toString());
            messagesData.remove(messag);
            notifyListeners();
          } catch (e) {
            print(
                "there is a problem saving and taking data from sharedpref $e");
          }
        }else {
          messag['sent'] = false;
          notifyListeners();
        }
      }
    }
    notifyListeners();
  }


  void sendSmsAfterFun(int sendAfter) {
    sendSmsAfter = sendAfter;
    SharedPrefHelper.saveString('send', sendAfter.toString());
    notifyListeners();
  }

  void chnageSendSmsStatus(bool status) {
    sendSms = status;
    notifyListeners();
  }
}
