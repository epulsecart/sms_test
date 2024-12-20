import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smsapp/data/internet_connections/api_settings.dart';
import 'package:smsapp/data/models/user_data.dart';
import 'package:smsapp/data/providers/messages_provider.dart';
import 'package:smsapp/data/providers/user_provider.dart';
import 'package:smsapp/data/repositories/get_messages.dart';
import 'package:smsapp/data/repositories/send_messages.dart';
import 'package:smsapp/helpers/shared_pref.dart';
import 'package:smsapp/modules/pages/messages.dart';
import 'package:smsapp/modules/pages/user_data.dart';
import 'package:smsapp/modules/styles/sizes.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:flutter/services.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:smsapp/modules/widgets/custom_text_form_field.dart';
import 'package:smsapp/modules/widgets/filled_button.dart';

import '../../helpers/routers.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isGranted = false;
  @override
  void initState() {

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async{
      isGranted =  await Permission.contacts.request().isGranted;
      getUserData();
      setState(() {

      });
    });
    controller = PersistentTabController(initialIndex: 1);
    super.initState();
  }

  void getUserData() async {
    String? num = await SharedPrefHelper.getString('X_MOBILE_ID');
    String? pass = await SharedPrefHelper.getString('X_USER_PASS');
    UserData userData = UserData(
        url: await SharedPrefHelper.getString('url'),
        xMOBILEID: int.parse(num!),
        xUSERNAME: await SharedPrefHelper.getString('X_USER_NAME'),
        xUSERPASS: int.parse(pass!));
    Provider.of<ApiFunNames>(context, listen: false)
        .getUrl(userData.url.toString());
    Provider.of<UserProvider>(context, listen: false).saveUserData(userData);
    GetMessagesRepo.getMessages(context,
        Provider.of<UserProvider>(context, listen: false).userData.toJson());
    // GetMessagesRepo.getMessages(context, userData.toJson());
  }

  late PersistentTabController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: controller,
        items: navBarItems(context),
        screens: screens(),
      ),
    );
  }

  List<PersistentBottomNavBarItem> navBarItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
          icon: Icon(Icons.person),
          activeColorPrimary: Theme.of(context).colorScheme.secondary,
          activeColorSecondary: Theme.of(context).primaryColor,
          inactiveIcon: Icon(
            Icons.person_outline_rounded,
            color: Theme.of(context).primaryColor,
          ),
          title: "الحساب",
          routeAndNavigatorSettings: const RouteAndNavigatorSettings(
              onGenerateRoute: Routes.generateRoute, initialRoute: '/')),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          activeColorPrimary: Theme.of(context).colorScheme.secondary,
          activeColorSecondary: Theme.of(context).primaryColor,
          inactiveIcon: Icon(
            Icons.home_outlined,
            color: Theme.of(context).primaryColor,
          ),
          title: "الرئيسية",
          routeAndNavigatorSettings: const RouteAndNavigatorSettings(
              onGenerateRoute: Routes.generateRoute, initialRoute: '/')),
      PersistentBottomNavBarItem(
          icon: const Icon(Icons.messenger),
          activeColorPrimary: Theme.of(context).colorScheme.secondary,
          activeColorSecondary: Theme.of(context).primaryColor,
          inactiveIcon: Icon(
            Icons.messenger_outline,
            color: Theme.of(context).primaryColor,
          ),
          title: "الرسائل",
          routeAndNavigatorSettings: const RouteAndNavigatorSettings(
              onGenerateRoute: Routes.generateRoute, initialRoute: '/')),
    ];
  }

  List<Widget> screens() {
    return [UserDataScreen(), MainScreen(), MessagesPage()];
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool smsMood = false;
  bool recieveSms = false;
  int x = 15;
  int _status = 0;
  List<DateTime> _events = [];
  Timer? timer;
  TextEditingController sendController = TextEditingController();
  TextEditingController receiveController = TextEditingController();
  bool isGranted = false;
  @override
  void initState() {
    receiveController.text = '15';
    sendController.text = '3';
    initPlatformState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      isGranted = await Permission.sms.request().isGranted ;
      if (!isGranted) await Permission.sms.request();
      if (await SharedPrefHelper.checkKey('rec')) {
        String tempRec = await SharedPrefHelper.getString('rec') ?? '15';
        int tempi = int.parse(tempRec);
        setState(() {
          x = tempi;
          receiveController.text = x.toString();
        });
      }

      if (await SharedPrefHelper.checkKey('send')) {
        String tempSend = await SharedPrefHelper.getString('send') ?? '5';
        int sendAfter = int.parse(tempSend);
        Provider.of<MessagesProvider>(context, listen: false)
            .sendSmsAfterFun(sendAfter);
        setState(() {
          sendController.text = sendAfter.toString();
        });
      }
    });
    super.initState();
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            requiredNetworkType: NetworkType.NONE), (String taskId) async {
      // <-- Event handler
      // This is the fetch-event callback.
      print("[BackgroundFetch] Event received $taskId");
      setState(() {
        _events.insert(0, DateTime.now());
      });
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    print('[BackgroundFetch] configure success: $status');
    setState(() {
      _status = status;
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _sendSmsEnable(enabled, List<String> numbers) async {
    setState(() {
      smsMood = enabled;
    });
    Provider.of<MessagesProvider>(context, listen: false).sendSms = enabled;
    if (enabled) {
      print("will send messages now");
      // SendMessages.sendSmsMessages(
      //     context, numbers);
    } else {}
  }

  void _recieveSmsEnable(enabled) async{
    setState(() {
      recieveSms = enabled;
    });
    if (enabled) {

      timer = Timer.periodic(Duration(seconds: x), (timer) async{
        List temp = await SharedPrefHelper.getList('numbers');
        print("temp is now ${temp.length}");
        print("checking for new messages");
        GetMessagesRepo.getMessages(
            context,
            Provider.of<UserProvider>(context, listen: false)
                .userData
                .toJson());
      });
    } else {
      if (timer != null) {
        timer!.cancel();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesProvider>(
      builder: (context, messages, child) => Scaffold(
        appBar: AppBar(
          title: Text("لوحة التحكم"),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: Sizing.getHeight(context, 100),
            width: Sizing.getWidth(context, 100),
            margin: Sizing.standaedEleMargine,
            padding: Sizing.standaedEleMargine,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isGranted? SizedBox(
                  width: MediaQuery.of(context).size.width ,
                  child: const Card(
                    color: Colors.lightGreen,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.check),
                          Text("تم منح صلاحية الارسال"),
                        ],
                      ),
                    ),
                  ),
                ):SizedBox(
                  width: MediaQuery.of(context).size.width ,
                  child: const Card(
                    color: Colors.redAccent,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.cancel_outlined),
                          Text("يحب منح الصلاحيات لارسال الرسائل"),
                        ],
                      ),
                    ),
                  ),
                ) ,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    const Text(" تفعيل وضع الإرسال في الخلفية"),
                    Switch(value: messages.sendSms, onChanged: (v){
                      _sendSmsEnable(v , messages.numbers);

                    }),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "البعد بين كل رساله والأخرى ",
                      style: TextStyle(
                          color: smsMood ? Colors.grey : Colors.black),
                    ),
                    SizedBox(
                      width: Sizing.getWidth(context, 40),
                      child: CustomTextFormField(
                        controller: sendController,
                        // initialValue: messages.sendSmsAfter.toString(),
                        onChanged: (value) {
                          setState(() {
                            if (value == null || value.isEmpty) {
                              messages.sendSmsAfter = 100;
                            } else {
                              print(
                                  "sendSms after is now ${messages.sendSmsAfter}");
                              messages.sendSmsAfter = int.parse(value);
                            }
                          });
                          messages.sendSmsAfterFun(messages.sendSmsAfter);
                        },
                        readOnly: smsMood,
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(" تفعيل وضع الإستقبال الأوتوماتيكي"),
                    Switch(value: recieveSms, onChanged: _recieveSmsEnable),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ارسال الطلب كل ",
                      style: TextStyle(
                          color: recieveSms ? Colors.grey : Colors.black),
                    ),
                    SizedBox(
                      width: Sizing.getWidth(context, 40),
                      child: CustomTextFormField(
                        controller: receiveController,
                        // initialValue: x.toString(),
                        onChanged: (value) {
                          setState(() {
                            if (value == null || value.isEmpty) {
                              x = 100;
                            } else {
                              print("x is now $x");
                              x = int.parse(value);
                              SharedPrefHelper.saveString('rec', x.toString());
                            }
                          });
                          timer!.cancel();
                          // _recieveSmsEnable(true);
                        },
                        readOnly: recieveSms,
                      ),
                    )
                  ],
                ),
                messages.recievedData && smsMood && messages.messagesData.isNotEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("عدد الرسائل قيد الأنتظار"),
                              Text(messages.messagesData.length.toString())
                            ],
                          ),
                          const Text("يتم الان ارسال الرسالة التالية"),
                          Text('''
                  الى الرقم ${messages.messagesData[0].keys.toString()}
                  ${messages.messagesData[0][messages.messagesData[0].keys.first][2].toString()} ''')
                        ],
                      )
                    : Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("عدد الرسائل قيد الأنتظار"),
                                Text(messages.messagesData.length.toString())
                              ],
                            ),
                          ],
                        ),
                      ),
                // FilledButton2(child: Text(), onPressedessed: onPressed)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
