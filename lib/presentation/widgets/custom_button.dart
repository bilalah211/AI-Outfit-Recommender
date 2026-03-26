import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';
import '../viewModel/upload_image_viewModel.dart';

class CustomButton extends StatelessWidget {
  final Widget? child;
  final String? title;
  final bool isLoading;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  const CustomButton({
    super.key,
    this.isLoading = false,
    this.title,
    this.height,
    this.width,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.appBar,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: isLoading ? CircularProgressIndicator() : child),
      ),
    );
  }
}
