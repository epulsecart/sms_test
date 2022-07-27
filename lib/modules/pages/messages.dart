import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsapp/data/providers/messages_provider.dart';
import 'package:smsapp/modules/styles/sizes.dart';

import '../../helpers/shared_pref.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
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
    Provider.of<MessagesProvider>(context, listen: false)
        .getMessagesFromSharedPref(numbers);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesProvider>(
      builder: (BuildContext context, messages, Widget? child) => Scaffold(
          appBar: AppBar(
            title: Text("الرسائل فيد الإرسال"),
          ),
          body: messages.recievedData
              ? ListView.builder(
                  itemBuilder: (context, index) => Container(
                    height: Sizing.getHeight(context, 15),
                    width: Sizing.getWidth(context, 90),
                    margin: Sizing.standaedEleMargine,
                    padding: Sizing.standaedEleMargine,
                    decoration: BoxDecoration(
                        borderRadius: Sizing.moreBorderRadius,
                        color: Colors.grey),
                    child: Text(
                      messages.messagesData[index][messages.numbers[index]][2]
                          .toString(),
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  itemCount: messages.numbers.length,
                )
              : Center()),
    );
  }
}
