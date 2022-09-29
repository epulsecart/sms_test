import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smsapp/modules/styles/sizes.dart';
import '../styles/input_deco.dart';

class CustomTextFormField extends StatelessWidget {
  final void Function(String? value)? onSave;
  final String? Function(String? value)? validator;
  final void Function(String? value)? onChanged;
  final int? maxLine;
  final Color? borderColor;
  final Widget? lable;
  final Color? hintColor;
  final double? borderWidth;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? margin;
  final String? hintText;
  final String? titleText;
  final bool obscureText;
  final TextInputType keyboardType;
  final int? maxLength;
  final int? minLines;
  final String? initialValue;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final bool readOnly;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String?)? onFieldSubmitted;
  final List<TextInputFormatter> inputFormatters;
  const CustomTextFormField({
    Key? key,
    this.onSave,
    this.validator,
    this.hintColor,
    this.onChanged,
    this.maxLine,
    this.lable,
    this.prefixIcon,
    this.hintText,
    this.titleText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.minLines,
    this.initialValue,
    this.suffixIcon,
    this.controller,
    this.readOnly = false,
    this.margin,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
    this.inputFormatters = const [],
    this.borderWidth,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Sizing.standaedEleMargine,
      padding: Sizing.standaedEleMargine,
      child: TextFormField(
          onFieldSubmitted: onFieldSubmitted,
          textInputAction: textInputAction ?? TextInputAction.next,
          focusNode: focusNode,
          readOnly: readOnly,
          maxLines: maxLine ?? 1,
          controller: controller,
          onSaved: onSave,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          initialValue: initialValue,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLength: maxLength,
          minLines: minLines,
          cursorColor: Theme.of(context).primaryColor,
          decoration: primaryInputDecorationTheme(
              hintColor: hintColor,
              context: context,
              hintText: hintText.toString(),
              prefexIcon: prefixIcon,
              filled: readOnly,
              sufIcon: suffixIcon)),
    );
  }
}
