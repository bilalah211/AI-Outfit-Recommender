import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/utils/app_urls.dart';
import '../models/clothing_model.dart';

class GeminiService {
  Future<Map<String, dynamic>> getRecommendation({
    required List<ClothingModel> wardrobe,
    required String occasion,
    required String weather,
  }) async {
    final url = Uri.parse(AppUrls.geminiBaseUrl);

    final prompt =
        """
You are a fashion AI stylist.

Occasion: $occasion
Weather: $weather

Wardrobe:
${wardrobe.map((item) => "- ${item.category}, ${item.color}, ${item.season}").join("\n")}

IMPORTANT:
- You MUST select items ONLY from the given wardrobe categories
- Do NOT invent new category names

Task:
Select the BEST outfit combination.

Return ONLY in JSON:
{
  "top": "",
  "bottom": "",
  "shoes": "",
  "reason": ""
}
""";

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode != 200) {
      print("ERROR: ${response.body}");
      throw Exception("Failed to get Gemini response");
    }

    final data = jsonDecode(response.body);

    final text = data['candidates'][0]['content']['parts'][0]['text'];

    return jsonDecode(text);
  }
}
