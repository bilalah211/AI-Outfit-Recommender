import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushbarHelperMessage {
  static void showMessage({
    required message,
    required background,

    required icon,
    required color,

    BuildContext? context,
  }) {
    Flushbar(
      message: message,
      icon: icon,
      messageColor: color,
      duration: Duration(seconds: 3),
      backgroundColor: background,
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(10),
    ).show(context!);
  }
}
