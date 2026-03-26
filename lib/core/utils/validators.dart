import 'package:flutter/cupertino.dart';

class ValidatorsHelper {
  static String? category(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Category is Required';
    }
    return null;
  }

  static String? color(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Color is Required';
    }
    return null;
  }

  static String? season(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Season is Required';
    }
    return null;
  }
}
