import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  // primary color
  static Color primaryColor = const Color(0xff3B5CA3);
  static Color errorColor = Colors.redAccent;
  // secondary color
  static Color secondaryColor = const Color(0xffCE4C4C);
  // blue color
  static Color profileColor = const Color(0xffBD916D);
  static Color iconColor = Colors.white;
  static Color textsColor = Colors.black;
  // purbel color
  static Color walletCardColor = const Color(0xffd93a30);
  // background color
  static Color backgroundColor = const Color(0xFFF1F1F1);
  // store action card background color
  static Color barGreenColor = const Color(0xff10A241);
  static Color storeActionCardBackgroundColor = const Color(0xFFF3B301);
  // subcription card background color
  static Color subscriptionCardBackgroundColor = const Color(0xFF965787);
  // kuraimi card label color
  static Color kuraimiCardLabelColor = const Color(0xFF6D57AA);
  static Color yemenMobile = const Color(0xFFD3395E);
  static Color sabaFone = const Color(0xFF6A89C5);
  static Color whyTele = const Color(0xFF9E68F2);
  static Color youTele = const Color(0xFFF7C85A);
  // gradient of auth pages background
  static LinearGradient authPageGradient = const LinearGradient(
    colors: [
      Color(0xffE7AED0),
      Color(0xff9CDAED),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static LinearGradient subscriptionCardGradiant = const LinearGradient(
    colors: [
      Color(0xFF965787),
      Color(0xffE7AED0),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static LinearGradient storeCardGradiant = const LinearGradient(
    colors: [
      Color(0xFFF3B301),
      Colors.white,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  // gradient of master page background
  static LinearGradient masterPageGradient = const LinearGradient(
    colors: [
      Color(0xff05526B),
      Color(0xff09A1D0),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static LinearGradient ProfilePageGradient = const LinearGradient(
    colors: [
      Color(0xffCC9D76),
      Colors.white,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  // home header gradient
  static LinearGradient homeHeaderGradient = const LinearGradient(
    colors: [
      Color(0xffD9D7ED),
      Color(0xffD7E4EC),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  // home balance card gradient
  static LinearGradient homeBalanceCardGradient = const LinearGradient(
    colors: [
      Color(0xffC2B3E5),
      Color(0xffC0C9E4),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  // profile background gradient
  static LinearGradient profileBackgroundGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0, 0.3, 1],
    colors: [
      Color(0xffCC9D76),
      Color(0xffCC9D76),
      Colors.white,
    ],
  );
}
