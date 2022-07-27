import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../styles/sizes.dart';

class FilledButton extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool fullWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final VoidCallback onPressed;
  final double? evalo;
  const FilledButton({
    Key? key,
    this.evalo,
    this.borderColor,
    required this.child,
    this.backgroundColor,
    this.borderRadius,
    this.fullWidth = false,
    this.padding,
    this.margin,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: fullWidth ? double.maxFinite : null,
      child: MaterialButton(
        elevation: evalo ?? 0,
        highlightElevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        padding: padding ?? const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor ?? Colors.transparent),
          borderRadius: borderRadius ?? Sizing.buttonBorderRadius,
        ),
        color: backgroundColor ?? Get.theme.primaryColor,
        child: DefaultTextStyle(
            style: TextStyle(
              color: Colors.white,
              fontFamily: Get.textTheme.button?.fontFamily,
              height: 1,
            ),
            child: child),
        onPressed: onPressed,
      ),
    );
  }
}
