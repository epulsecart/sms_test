import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsapp/data/internet_connections/api_settings.dart';
import 'package:smsapp/data/providers/messages_provider.dart';
import 'package:smsapp/data/providers/user_provider.dart';
import 'package:smsapp/generated/l10n.dart';
import 'package:smsapp/modules/styles/main_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../helpers/routers.dart';

class SmsApp extends StatefulWidget {
  final bool userExits;
  const SmsApp({Key? key, required this.userExits}) : super(key: key);

  @override
  State<SmsApp> createState() => _SmsAppState();
}

class _SmsAppState extends State<SmsApp> {
  @override
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MessagesProvider>(
            create: (context) => MessagesProvider()),
        ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider()),
        ChangeNotifierProvider<ApiFunNames>(create: (context) => ApiFunNames()),
      ],
      child: Builder(
        builder: (context) => MaterialApp(
          theme: appThemeData,
          onGenerateRoute: Routes.generateRoute,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale.fromSubtags(languageCode: 'ar'),
          supportedLocales: S.delegate.supportedLocales,
          initialRoute: widget.userExits ? '/' : 'userDataScreen',
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}
