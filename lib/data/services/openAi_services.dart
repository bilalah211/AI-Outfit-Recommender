import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/utils/app_strings.dart';
import '../../core/utils/app_urls.dart';
import '../models/clothing_model.dart';

class HuggingFaceService {
  Future<Map<String, dynamic>> getRecommendation({
    required List<ClothingModel> wardrobe,
    required String occasion,
    required String weather,
  }) async {
    final url = Uri.parse(AppUrls.openRouterBaseUrl);

    String prompt =
        """
You are a fashion assistant.

Wardrobe:
${wardrobe.map((e) => "- ID: ${e.id}, Category: ${e.category}, Color: ${e.color}, Season: ${e.season}").join("\n")}

Occasion: $occasion
Weather: $weather

Return ONLY JSON:
{
  "top": "item_id_here",
  "bottom": "item_id_here",
  "shoes": "item_id_here"
}
""";

    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer ${AppStrings.openRouterApiKey}",
        "Content-Type": "application/json",
        "HTTP-Referer": "https://yourapp.com",
        "X-Title": "Outfit Recommender App",
      },
      body: jsonEncode({
        "model": "openai/gpt-3.5-turbo",
        "messages": [
          {
            "role": "system",
            "content": "Return ONLY valid JSON, no explanation.",
          },
          {"role": "user", "content": prompt},
        ],
        "temperature": 0.7,
      }),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed: ${response.statusCode}");
    }

    final data = jsonDecode(response.body);
    final text = data["choices"][0]["message"]["content"];

    String cleanedText = text.trim();

    if (cleanedText.contains("{")) {
      cleanedText = cleanedText.substring(
        cleanedText.indexOf("{"),
        cleanedText.lastIndexOf("}") + 1,
      );
    }

    return jsonDecode(cleanedText);
  }
}
