import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsapp/data/internet_connections/api_settings.dart';
import 'package:smsapp/data/models/user_data.dart';
import 'package:smsapp/data/providers/user_provider.dart';
import 'package:smsapp/data/repositories/get_messages.dart';
import 'package:smsapp/helpers/shared_pref.dart';
import 'package:smsapp/helpers/validators.dart';
import 'package:smsapp/modules/styles/colors.dart';
import 'package:smsapp/modules/styles/sizes.dart';
import 'package:smsapp/modules/widgets/filled_button.dart';

import '../widgets/custom_text_form_field.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({Key? key}) : super(key: key);
  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  UserData userData = UserData();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      checkUser();
    });
    super.initState();
  }

  void checkUser() async {
    bool userExists = await SharedPrefHelper.getBool('exist');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, user, child) {
      if (user.user_exist) {
        userData = user.userData;
      }
      return Scaffold(
        appBar: AppBar(
          title: Text("بينات المستخدم"),
        ),
        body: Container(
          height: Sizing.getHeight(context, 100),
          width: Sizing.getWidth(context, 100),
          margin: Sizing.standaedEleMargine,
          padding: Sizing.standaedEleMargine,
          decoration: BoxDecoration(),
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text("الرجاء ادخال البيانات التالية"),
                  ),
                  CustomTextFormField(
                    hintText: ('اسم المستخدم'),
                    initialValue:
                        user.user_exist ? user.userData.xUSERNAME : null,
                    suffixIcon: Icon(Icons.person),
                    onChanged: (value) {
                      userData.xUSERNAME = value;
                    },
                    validator: (value) {
                      return Validator.validate(
                          value: value, rules: ['required']);
                    },
                  ),
                  CustomTextFormField(
                    hintText: ('كلمة السر'),
                    initialValue: user.user_exist
                        ? user.userData.xUSERPASS.toString()
                        : null,
                    keyboardType: TextInputType.number,
                    suffixIcon: Icon(Icons.remove_red_eye_rounded),
                    onChanged: (value) {
                      userData.xUSERPASS = int.parse(value!);
                    },
                    validator: (value) {
                      return Validator.validate(
                          value: value, rules: ['required', 'minLength:8']);
                    },
                  ),
                  CustomTextFormField(
                    hintText: ('كود الهاتف'),
                    suffixIcon: Icon(Icons.mobile_friendly),
                    keyboardType: TextInputType.number,
                    initialValue: user.user_exist
                        ? user.userData.xMOBILEID.toString()
                        : null,
                    onChanged: (value) {
                      userData.xMOBILEID = int.parse(value!);
                    },
                    validator: (value) {
                      return Validator.validate(
                          value: value, rules: ['required', 'minLength:4']);
                    },
                  ),
                  CustomTextFormField(
                    hintText: ('عنوان السيرفر'),
                    suffixIcon: Icon(Icons.web),
                    initialValue: user.user_exist
                        ? user.userData.url
                        : 'unitedsoft.com.ye',
                    onChanged: (value) {
                      userData.url = value;
                    },
                    validator: (value) {
                      return Validator.validate(
                          value: value, rules: ['required']);
                    },
                  ),
                  FilledButton2(
                    child: Text("حفظ"),
                    onPressed: () {
                      if (_key.currentState!.validate()) {
                        print(
                            "the values here are ${userData.xUSERNAME} ${userData.xUSERPASS}, ${userData.xMOBILEID}");
                        SharedPrefHelper.saveString(
                            'X_USER_NAME', userData.xUSERNAME!);
                        SharedPrefHelper.saveString(
                            'X_USER_PASS', userData.xUSERPASS.toString());
                        SharedPrefHelper.saveString(
                            'X_MOBILE_ID', userData.xMOBILEID.toString());
                        if (userData.url == null || userData.url!.isEmpty) {
                          userData.url = 'unitedsoft.com.ye';
                        }
                        SharedPrefHelper.saveString('url', userData.url!);
                        Provider.of<ApiFunNames>(context, listen: false)
                            .getUrl(userData.url!);
                        GetMessagesRepo.getMessages(context, userData.toJson());
                        Navigator.of(context).pushNamed('/');
                      }
                    },
                    backgroundColor: AppColors.primaryColor,
                    fullWidth: true,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
