import 'package:easy_localization/easy_localization.dart';

class ValidatorUtils {
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'form.phone-number-required-msg'.tr();
    }
    if (value.length != 10) {
      return 'form.phone-number-invalid-msg'.tr();
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'form.phone-number-invalid-msg'.tr();
    }

    return null;
  }
}