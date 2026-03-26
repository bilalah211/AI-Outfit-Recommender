import 'package:ai_outfit_recommender/presentation/views/outfit_details_screen.dart';
import 'package:flutter/material.dart';

import '../../presentation/views/home_screen.dart';
import '../../presentation/views/saved_outfit_screen.dart';
import '../../presentation/views/my_wardrobe_screen.dart';
import '../../presentation/views/recommendation_screen.dart';
import '../../presentation/views/splash_screen.dart';
import '../../presentation/views/upload_image_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String upload = '/upload';
  static const String wardrobe = '/wardrobe';
  static const String recommendation = '/recommendation';
  static const String saved = '/saved';
  static const String details = '/details';
}

class AppRouter {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (context) => SplashScreen());

      case AppRoutes.home:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      case AppRoutes.upload:
        return MaterialPageRoute(builder: (context) => UploadImageScreen());
      case AppRoutes.wardrobe:
        return MaterialPageRoute(builder: (context) => MyWardrobeScreen());
      case AppRoutes.recommendation:
        return MaterialPageRoute(builder: (context) => RecommendationScreen());

      case AppRoutes.saved:
        return MaterialPageRoute(builder: (context) => SavedOutFitScreen());

      default:
        return MaterialPageRoute(
          builder: (context) =>
              Scaffold(body: Center(child: Text("No Route Found"))),
        );
    }
  }
}
