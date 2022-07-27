import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:smsapp/data/internet_connections/http_calls.dart';
import 'package:smsapp/data/repositories/send_messages.dart';
import 'package:smsapp/helpers/shared_pref.dart';
import 'package:smsapp/modules/main_class.dart';
import 'package:flutter/services.dart';
import 'package:background_fetch/background_fetch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool userExist = await SharedPrefHelper.getBool('exist');
  runApp(SmsApp(userExits: userExist));

  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  print("the work will start now");
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');
  // SendMessages.sendSmsMessages();
  BackgroundFetch.finish(taskId);
}



/*
 void sendMessageTest() async {
    // print("now this is sending the message ");
    // String message = "This is a test message!";
    // List<String> recipents = ["771221030", "777151565"];
    //
    // String _result =
    //     await sendSMS(message: message, recipients: recipents, sendDirect: true)
    //         .catchError((onError) {
    //   print("error ecured");
    //   print(onError);
    // });
    // print(_result);
  }
 */
