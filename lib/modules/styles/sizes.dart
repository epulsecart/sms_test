import 'package:flutter/cupertino.dart';

class Sizing {
  static double getHeight(BuildContext context, double x) {
    return MediaQuery.of(context).size.height / 100 * x;
  }

  static double getWidth(BuildContext context, double x) {
    return MediaQuery.of(context).size.width / 100 * x;
  }

  static BorderRadius buttonBorderRadius = BorderRadius.circular(8);
  static BorderRadius cardBorderRadius = BorderRadius.circular(8);
  static BorderRadius masterBorderRadius = const BorderRadius.only(
    bottomLeft: Radius.circular(12),
    bottomRight: Radius.circular(12),
  );

  // padding
  static EdgeInsets authPagesPadding = const EdgeInsets.all(32);
  static EdgeInsets pagesPadding = const EdgeInsets.all(16);
  static BorderRadius standardBorderRadius = BorderRadius.circular(8);
  static BorderRadius onlyDownBorderRadius = const BorderRadius.only(
      bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8));
  static BorderRadius onlyTopBorderRadius = const BorderRadius.only(
      topRight: Radius.circular(8), topLeft: Radius.circular(8));
  static BorderRadius moreBorderRadius = BorderRadius.circular(15);
  static EdgeInsets standaedEleMargine = EdgeInsets.all(10);
}
