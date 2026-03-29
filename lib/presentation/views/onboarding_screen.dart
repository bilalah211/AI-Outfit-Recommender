import 'package:ai_outfit_recommender/core/themes/app_colors.dart';
import 'package:ai_outfit_recommender/core/themes/app_text_styles.dart';
import 'package:ai_outfit_recommender/core/utils/app_routes.dart';
import 'package:ai_outfit_recommender/data/models/onboarding_model.dart';
import 'package:ai_outfit_recommender/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/utils/shared_preferences_helper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: controller,
          itemCount: onboardingPages.length,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        controller.animateToPage(
                          onboardingPages.length - 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ),
                  SizedBox(height: 150),

                  Container(
                    height: MediaQuery.of(context).size.height / 3.3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage(onboardingPages[index].image),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  //---[Smooth Indicator]---
                  _buildSmoothPageIndicator(),
                  SizedBox(height: 20),

                  //---[Title]---
                  _buildText(
                    index,
                    onboardingPages[index].title,
                    AppTextStyles.appTitle.copyWith(color: Colors.black87),
                  ),
                  //---[Description]---
                  _buildText(index, onboardingPages[index].description, null),

                  SizedBox(height: 200),
                  Row(
                    children: [
                      //---[Arrow Back Button]---
                      currentIndex > 0
                          ? _buildOutlinedButton(
                              onPressed: () => controller.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.decelerate,
                              ),
                              Icon(Icons.arrow_back_ios_new),
                            )
                          : SizedBox(),
                      Spacer(),
                      currentIndex == onboardingPages.length - 1
                          ? CustomButton(
                              height: MediaQuery.sizeOf(context).height / 15,
                              width: MediaQuery.sizeOf(context).width / 2,
                              onTap: () async {
                                if (currentIndex ==
                                    onboardingPages.length - 1) {
                                  //  Save that onboarding is completed
                                  await SharedPreferencesHelper.setIsFirstTime();

                                  //  Navigate to Home
                                  Navigator.pushNamed(context, AppRoutes.home);
                                } else {
                                  controller.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.decelerate,
                                  );
                                }
                              },
                              child: Text(
                                'Get Started',
                                style: AppTextStyles.buttonText,
                              ),
                            )
                          : SizedBox(),
                      Spacer(),

                      //---[Arrow Forward Button]---
                      currentIndex != onboardingPages.length - 1
                          ? _buildOutlinedButton(
                              Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                controller.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.decelerate,
                                );
                              },
                            )
                          : SizedBox(),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildText(int index, String title, TextStyle? style) {
    return Align(
      alignment: Alignment.center,
      child: Center(child: Text(title, style: style)),
    );
  }

  //---[Outline Button]---

  Widget _buildOutlinedButton(Widget child, {required VoidCallback onPressed}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(shape: CircleBorder()),
      onPressed: onPressed,

      child: child,
    );
  }

  //---[Smooth Indicator]---
  Widget _buildSmoothPageIndicator() {
    return SmoothPageIndicator(
      controller: controller,
      count: onboardingPages.length,
      effect: ExpandingDotsEffect(
        expansionFactor: 5,
        activeDotColor: AppColors.primary,
        dotHeight: 10,
        dotWidth: 10,
      ),
    );
  }
}
