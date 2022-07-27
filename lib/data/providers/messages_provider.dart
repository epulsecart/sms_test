import 'package:flutter/cupertino.dart';
import 'package:smsapp/data/models/messages.dart';
import 'package:smsapp/helpers/shared_pref.dart';

class MessagesProvider with ChangeNotifier {
  bool recievedData = false;
  List<Map<String, dynamic>> messagesData = [];
  List<String> numbers = [];

  void getMessages(List messagesList) {
    if (messagesList.isEmpty) {
      return;
    }
    messagesData = [];
    numbers = [];
    messagesList.forEach((element) {
      List<String> currentMessage = [
        element['MOBILE_NO'].toString(),
        element['YEAR_ID'].toString(),
        element['SHURT_MESSAGE'].toString(),
      ];
      SharedPrefHelper.saveList(
          element['SERIAL_ID'].toString(), currentMessage);
      messagesData.add({element['SERIAL_ID'].toString(): currentMessage});
      numbers.add(element['SERIAL_ID'].toString());
    });
    SharedPrefHelper.saveList('numbers', numbers);
    if (messagesData.isNotEmpty || numbers.isNotEmpty) {
      recievedData = true;
    } else {
      recievedData = false;
    }
    notifyListeners();
  }

  Future getMessagesFromSharedPref(List<String> numbers) async {
    if (numbers.isEmpty) {
      recievedData = false;
      notifyListeners();
      return;
    }
    try {
      messagesData = [];
      await Future.forEach(numbers, (element) async {
        List data = await SharedPrefHelper.getList(element.toString());
        Map<String, dynamic> messageData = {element.toString(): data};
        this.messagesData.add(messageData);
      });
      if (messagesData.isNotEmpty || numbers.isNotEmpty) {
        recievedData = true;
      } else {
        recievedData = false;
      }
      notifyListeners();
    } catch (e) {
      print(
          "hi there is a problem in getting the data from shared pref in message_provider $e");
    }
  }
}
