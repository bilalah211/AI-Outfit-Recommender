import 'package:ai_outfit_recommender/core/utils/app_routes.dart';
import 'package:ai_outfit_recommender/core/utils/Flushbar_helper.dart';
import 'package:ai_outfit_recommender/data/services/firebase_services.dart';
import 'package:ai_outfit_recommender/presentation/viewModel/my_wardrobe_viewModel.dart';
import 'package:ai_outfit_recommender/presentation/viewModel/openAI_viewModel.dart';
import 'package:ai_outfit_recommender/presentation/viewModel/upload_image_viewModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'core/utils/app_strings.dart';

void main() async {
  //---[Initializing Firebase]---
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //---[For Secure Secret Keys]---
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //---[Providers]---
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UploadImageVM()),
        ChangeNotifierProvider(create: (_) => MyWardrobeViewModel()),
        ChangeNotifierProvider(create: (_) => OpenAIViewModel()),
        ChangeNotifierProvider(create: (_) => FirebaseServices()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),

        //---[Initial Routes]---
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.generateRoutes,
      ),
    );
  }
}
