import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../../core/utils/app_routes.dart';
import '../../core/utils/app_images.dart';
import '../widgets/card.dart';
import '../widgets/custom_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Welcome!', showBack: false),

      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          children: [
            CustomCard(
              text: 'Add Clothes',
              imagePath: AppImages.camera,
              linearGradient: AppColors.primaryGradient,
              onTap: () => Navigator.pushNamed(context, AppRoutes.upload),
            ),
            CustomCard(
              text: 'My Wardrobe',
              imagePath: AppImages.wardrobe,
              linearGradient: AppColors.card2,
              height: 60,
              onTap: () => Navigator.pushNamed(context, AppRoutes.wardrobe),
            ),
            CustomCard(
              text: 'Get \nRecommendations',
              imagePath: AppImages.light,
              linearGradient: AppColors.card3,
              height: 80,
              spacing: 20,
              onTap: () =>
                  Navigator.pushNamed(context, AppRoutes.recommendation),
            ),
            CustomCard(
              text: 'Saved Outfits',
              imagePath: AppImages.heart,
              linearGradient: AppColors.card4,
              height: 60,
              onTap: () => Navigator.pushNamed(context, AppRoutes.saved),
            ),
          ],
        ),
      ),
    );
  }
}
