import 'package:get/get.dart';

class Validator {
  /// Validate the value with the rules.
  ///
  ///
  /// [value] the value to validate.
  /// [rules] the rules to validate the value.
  ///
  /// available rules:
  /// * 'required' - the value is required.
  /// * 'minLength:value' - the value length must be greater than or equal to the specified value.
  /// * 'maxLength:value' - the value length must be less than or equal to the specified value.
  /// * 'length:value' - the value length must be equal to the specified value.
  /// * 'minValue:value' - the value must be greater than or equal to the specified value.
  /// * 'maxValue:value' - the value must be less than or equal to the specified value.
  /// * 'email' - the value must be a valid email address.
  /// * 'url' - the value must be a valid url.
  /// * 'numeric' - the value must be a valid number.
  /// * 'numericBetween:value1,value2' - the value must be a valid number between the specified values.
  /// * 'alpha' - the value must be a valid alpha character.
  /// * 'alphaNumeric' - the value must be a valid alpha numeric character.
  /// * 'alphaDash' - the value must be a valid alpha dash character.
  /// * 'alphaDashNumeric' - the value must be a valid alpha dash numeric character.
  /// * 'oneOf:value1,value2,value3' - the value must be one of the specified values.
  /// * 'notOneOf:value1,value2,value3' - the value must not be one of the specified values.
  /// * 'creditCard' - the value must be a valid credit card number.
  static String? validate({dynamic value, List<String>? rules}) {
    if (rules != null) {
      for (var rule in rules) {
        if (rule.startsWith('required')) {
          if (value == null || value.toString().isEmpty) {
            return 'هذا الحقل مطلوب';
          }
        } else if (rule.startsWith('minLength')) {
          var min = int.parse(rule.split(':')[1]);
          if (value != null && value.toString().length < min) {
            return 'يجب ان يتكون هذا الحقل من عدد لا يقل عن${min.toString()}'
                .trParams({"min": min.toString()});
          }
        } else if (rule.startsWith('maxLength')) {
          var max = int.parse(rule.split(':')[1]);
          if (value != null && value.toString().length > max) {
            return 'يجب ان لا يزيد هذا الحقل عن${max.toString()}'
                .trParams({"max": max.toString()});
          }
        } else if (rule.startsWith('length')) {
          var length = int.parse(rule.split(':')[1]);
          if (value != null && value.toString().length != length) {
            return 'يجب ان يكون هذا الحقل عدد'
                .trParams({"length": length.toString()});
          }
        } else if (rule.startsWith('minValue')) {
          var min = int.parse(rule.split(':')[1]);
          if (value != null && value < min) {
            return 'يجب ان لا تقل قيمة هذا الحقل عن ${min.toString()}'
                .trParams({"min": min.toString()});
          }
        } else if (rule.startsWith('maxValue')) {
          var max = int.parse(rule.split(':')[1]);
          if (value != null && value > max) {
            return 'يجب ان لا تزيد قيمة هذا الحقل عن ${max.toString()}'
                .trParams({"max": max.toString()});
          }
        } else if (rule.startsWith('email')) {
          if (value != null && (GetUtils.isEmail(value.toString()) == false)) {
            return 'يجب ادخال البريد بصورة صحيحة';
          }
        } else if (rule.startsWith('url')) {
          if (value != null &&
              !RegExp(r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)$')
                  .hasMatch(value)) {
            return 'لا تبدوا البيانات صحيحة';
          }
        }
        // else if (rule.startsWith('greaterThan')) {
        //   var greaterThan = int.parse(rule.split(':')[1]);
        //   if (value != null && value.toString().length <= greaterThan) {
        //     return 'greaterThanValidationMessage'
        //         .trParams({"greaterThan": greaterThan.toString()});
        //   }
        // } else if (rule.startsWith('lessThan')) {
        //   var lessThan = int.parse(rule.split(':')[1]);
        //   if (value != null && value.toString().length >= lessThan) {
        //     return 'lessThanValidationMessage'
        //         .trParams({"lessThan": lessThan.toString()});
        //   }
        // }
        else if (rule.startsWith('phone')) {
          if (value != null &&
              !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')
                  .hasMatch(value)) {
            return 'يجب ان يتكون هذا الحقل من ارقام انجليزية فقط';
          }
        } else if (rule.startsWith('numeric')) {
          if (value != null && !RegExp(r'^[0-9]*$').hasMatch(value)) {
            return 'يجب ان يتكون هذا الحقل من ارقام انجليزية فقط';
          }
        } else if (rule.startsWith('numericBetween')) {
          var numeric = rule.split(':')[1];
          var min = int.parse(numeric.split(',')[0]);
          var max = int.parse(numeric.split(',')[1]);
          int v = int.parse(value.toString());
          if (value != null &&
              !RegExp(r'^[0-9]*$').hasMatch(value) &&
              (v < min || v > max)) {
            return 'الرقم ليس في المدى الصحيح';
          }
        } else if (rule.startsWith('alpha')) {
          if (value != null && !RegExp(r'^[a-zA-Z]*$').hasMatch(value)) {
            return 'يجب ان يتكون هذا الحقل من احرف انجليزية فقط';
          }
        } else if (rule.startsWith('alphaNumeric')) {
          if (value != null && !RegExp(r'^[a-zA-Z0-9]*$').hasMatch(value)) {
            return 'يجب ان يتكون هذا الحقل من ارقام واحرف انجليزية';
          }
        } else if (rule.startsWith('alphaDash')) {
          if (value != null && !RegExp(r'^[a-zA-Z0-9_\-]*$').hasMatch(value)) {
            return 'يجب ان يتكون هذا الحقل من ارقام واحرف ورموز';
          }
        } else if (rule.startsWith('date')) {
          if (value != null &&
              !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
            return 'dateValidationMessage';
          }
        } else if (rule.startsWith('oneOf')) {
          var temp = rule.split(':')[1];
          var values = temp.split(',');
          if (value != null && !values.contains(value)) {
            return 'oneOfValidationMessage'.tr;
          }
        } else if (rule.startsWith('notOneOf')) {
          var temp = rule.split(':')[1];
          var values = temp.split(',');
          if (value != null && values.contains(value)) {
            return 'notOneOfValidationMessage'.tr;
          }
        } else if (rule.startsWith('creditCard')) {
          if (value != null &&
              !RegExp(r'^(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})$')
                  .hasMatch(value)) {
            return 'creditCardValidationMessage'.tr;
          }
        } else if (rule.startsWith('regex')) {
          var temp = rule.split(':')[1];
          var regex = RegExp(temp);
          if (value != null && !regex.hasMatch(value)) {
            return 'regexValidationMessage'.tr;
          }
        } else if (rule.startsWith('same')) {
          var same = rule.split(':')[1];
          var sameValue = rule.split(':')[2];
          if (value != null && value.toString() != sameValue) {
            return 'sameValidationMessage'.trParams({"same": same.tr});
          }
        } else {
          assert(false, 'Unknown validation rule: $rule');
        }
      }
    }
    return null;
  }
}
