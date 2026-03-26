import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppStrings {
  static const String appName = "AI Outfit Recommender App";
  static const String uploadImage = "Upload Image";
  static const String login = "Login";
  static const String signup = "Sign Up";
  static const String welcome = "Welcome Back";

  //---[Cloudinary]---
  static const String cloudName = "dnpc62ouy";
  static const String uploadPreset = "ai_outfit_recommender";

  //---[GeminiAI ApiKey]---

  static final String geminiAiApiKey = dotenv.env['geminiAiApiKey']!;
}
