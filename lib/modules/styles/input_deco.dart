import 'package:flutter/material.dart';
import 'package:smsapp/modules/styles/sizes.dart';

InputDecoration primaryInputDecorationTheme(
    {required BuildContext context,
    String? hintText,
    Widget? sufIcon,
    Widget? prefexIcon,
    Color? hintColor,
    bool? filled}) {
  return InputDecoration(
    hintText: hintText,
    suffixIcon: sufIcon,
    prefixIcon: prefexIcon,
    hintStyle: TextStyle(
      color: hintColor ?? Colors.black,
      fontSize: 12,
    ),
    hoverColor: Theme.of(context).primaryColor,
    focusColor: Theme.of(context).primaryColor,
    fillColor: Colors.white,
    filled: true,
    errorMaxLines: 2,
    errorStyle: const TextStyle(
      color: Colors.redAccent,
      fontSize: 12,
    ),
    contentPadding: const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 16,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.1,
        color: Colors.grey.shade500,
      ),
      borderRadius: Sizing.moreBorderRadius,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.1,
        color: Theme.of(context).primaryColor,
      ),
      borderRadius: Sizing.moreBorderRadius,
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(
        width: 1,
        color: Colors.redAccent,
      ),
      borderRadius: Sizing.moreBorderRadius,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 0.1,
        color: Colors.grey.shade500,
      ),
      borderRadius: Sizing.moreBorderRadius,
    ),
    alignLabelWithHint: true,
  );
}
