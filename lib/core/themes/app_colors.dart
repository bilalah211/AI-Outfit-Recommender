import 'dart:ui';
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF4F7CFF);
  static const Color secondary = Color(0xFF7B5CFF);

  static const Color appBar = Color(0xFF3F6FB3);

  static const Color background = Color(0xFFF5F7FB);
  static final Color card = Colors.white;

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  static const Color greyContainer = Colors.grey;

  static final Color buttonText = Colors.white;

  static final Gradient primaryGradient = LinearGradient(
    colors: [Colors.blue, Colors.pink.shade300],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static final Gradient card2 = LinearGradient(
    colors: [Colors.blue, Colors.deepPurple.shade500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static final Gradient card3 = LinearGradient(
    colors: [Colors.orange.shade300, Colors.purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static final Gradient card4 = LinearGradient(
    colors: [Colors.purple.shade300, Colors.blue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
