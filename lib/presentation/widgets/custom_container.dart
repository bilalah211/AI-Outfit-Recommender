import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';

class CustomContainer extends StatelessWidget {
  final String? imagePath;
  final File? fileImage;
  final Widget? child;
  final bool isFileImage;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  const CustomContainer({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.margin,
    this.padding,
    this.fileImage,
    this.isFileImage = false,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      height: height,
      width: width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        color: AppColors.greyContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }
}
