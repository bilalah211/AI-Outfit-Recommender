import 'package:ai_outfit_recommender/core/utils/app_routes.dart';
import 'package:ai_outfit_recommender/core/utils/shared_preferences_helper.dart';
import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    deciderScreen();
    super.initState();
  }

  Future<void> deciderScreen() async {
    await Future.delayed(Duration(seconds: 3));

    bool isFirstTime = await SharedPreferencesHelper.isFirstTime();

    if (isFirstTime) {
      Navigator.pushNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(gradient: AppColors.primaryGradient),
          ),

          // Splash Logo
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/splash logos/splash logo.png',
              width: MediaQuery.of(context).size.width / 1,
              height: MediaQuery.of(context).size.height / 1.5,
              fit: BoxFit.cover,
            ),
          ),

          //Splash Screen Text
          Positioned(
            bottom: 250,
            left: 0,
            right: 0,
            child: Text(
              "AI Outfit",
              textAlign: TextAlign.center,
              style: AppTextStyles.appTitle,
            ),
          ),
          Positioned(
            bottom: 220,
            left: 0,
            right: 0,
            child: Text(
              "Recommender",
              textAlign: TextAlign.center,
              style: AppTextStyles.appTitle,
            ),
          ),
          Positioned(
            bottom: 200,
            left: 0,
            right: 0,
            child: Text(
              "Your Smart Fashion Assistant",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText.copyWith(color: AppColors.card),
            ),
          ),
        ],
      ),
    );
  }
}
