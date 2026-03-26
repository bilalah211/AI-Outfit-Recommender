import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onTap;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.onTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appBar,
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: showBack
          ? GestureDetector(
              onTap: onTap ?? () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios_new, color: Colors.white),
            )
          : null,
      actionsPadding: EdgeInsets.symmetric(horizontal: 13),
      actions: actions,
      title: Text(
        title,
        style: TextStyle(color: AppColors.card, fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
