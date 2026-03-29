import 'package:ai_outfit_recommender/core/utils/app_images.dart';

class OnboardingModel {
  final String title;
  final String description;
  final String image;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.image,
  });
}

final List<OnboardingModel> onboardingPages = [
  OnboardingModel(
    title: "Snapshot Your Style",
    description:
        "Take a photo of your clothes to add them to your digital vault.",
    image: AppImages.onboarding1,
  ),
  OnboardingModel(
    title: "Your AI Stylist",
    description: "Get perfect outfit matches from the clothes you already own.",
    image: AppImages.onboarding2,
  ),

  OnboardingModel(
    title: "Smart Style Filters",
    description: "Select your occasion and the weather for a tailored look.",
    image: AppImages.onboarding3,
  ),
];
