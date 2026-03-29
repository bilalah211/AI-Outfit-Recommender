import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static TextStyle appTitle = GoogleFonts.poppins(
    fontSize: 25,
    fontWeight: FontWeight.bold,
    color: AppColors.buttonText,
  );

  static TextStyle screenTitle = GoogleFonts.poppins(
    fontSize: 19,

    color: AppColors.textPrimary,
  );

  static TextStyle buttonText = GoogleFonts.poppins(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static TextStyle smallText = GoogleFonts.poppins(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}
