import 'package:flutter/material.dart';

import '../modules/pages/home.dart';
import '../modules/pages/messages.dart';
import '../modules/pages/user_data.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => Home(),
        );
      case 'userDataScreen':
        return MaterialPageRoute(
          builder: (_) => UserDataScreen(),
        );
      case 'messagesPage':
        return MaterialPageRoute(
          builder: (_) => MessagesPage(),
        );
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
