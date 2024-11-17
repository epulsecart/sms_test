import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsapp/data/providers/messages_provider.dart';
import 'package:smsapp/modules/styles/colors.dart';
import 'package:smsapp/modules/styles/sizes.dart';

import '../../helpers/shared_pref.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final GlobalKey _dismiskey = GlobalKey();
  late List<String> numbers;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getMessages();
    });
    super.initState();
  }

  void getMessages() async {
    numbers = await SharedPrefHelper.getList('numbers');
    // Provider.of<MessagesProvider>(context, listen: false)
    //     .getMessagesFromSharedPref(numbers);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesProvider>(
      builder: (BuildContext context, messages, Widget? child) => Scaffold(
          appBar: AppBar(
            title:  Text("الرسائل ${messages.recievedData}فيد الإرسال"),
          ),
          body: ListView.builder(
            itemBuilder: (context, index) => messages.recievedData
                ? Card(
                    margin: Sizing.standaedEleMargine,
                    child: Column(
                      children: [
                        Container(
                          height: Sizing.getHeight(context, 5),
                          width: Sizing.getWidth(context, 90),
                          margin: Sizing.standaedEleMargine,
                          padding: Sizing.standaedEleMargine,
                          decoration: const BoxDecoration(
                              //    gradient: AppColors.masterPageGradient
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("الى"),
                              Text(
                                messages.messagesData[index]['MOBILE_NO']
                                    .toString(),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: Sizing.getHeight(context, 15),
                          width: Sizing.getWidth(context, 90),
                          margin: Sizing.standaedEleMargine,
                          padding: Sizing.standaedEleMargine,
                          decoration: BoxDecoration(
                              borderRadius: Sizing.moreBorderRadius,
                              color: AppColors.barGreenColor),
                          child: Text(
                            messages.messagesData[index]['SHURT_MESSAGE']
                                .toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  )
                : const Center(),
            itemCount: messages.messagesData.length,
          )),
    );
  }
}
