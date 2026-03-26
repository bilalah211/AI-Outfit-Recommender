import 'package:flutter/material.dart';

import '../../core/themes/app_text_styles.dart';

class CustomCard extends StatelessWidget {
  final String text;
  final String imagePath;
  final VoidCallback? onTap;
  final Gradient linearGradient;
  final double height;
  final double spacing;

  const CustomCard({
    super.key,
    required this.text,
    required this.imagePath,
    this.onTap,
    required this.linearGradient,
    this.height = 65,
    this.spacing = 30,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),

        height: MediaQuery.of(context).size.height / 8.5,
        decoration: BoxDecoration(
          gradient: linearGradient,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: spacing),
              child: Image.asset(
                imagePath,
                color: Colors.white,
                height: height,
              ),
            ),

            Text(text, style: AppTextStyles.appTitle.copyWith(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
