import 'package:ai_outfit_recommender/core/utils/app_strings.dart';

class AppUrls {
  //---[Cloudinary URLS]---

  static const String cloudinaryApiUrl =
      'https://api.cloudinary.com/v1_1/${AppStrings.cloudName}/image/upload';

  //---[GeminiAI URLS]---

  static final String openRouterBaseUrl =
      'https://openrouter.ai/api/v1/chat/completions';
}
