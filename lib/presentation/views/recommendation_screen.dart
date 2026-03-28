import 'package:ai_outfit_recommender/presentation/viewModel/openAI_viewModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/themes/app_text_styles.dart';
import '../../core/utils/Flushbar_helper.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  String selectedOccasion = 'Office';
  String selectedWeather = 'Cool';
  final List<String> occasions = [
    'Casual',
    'Office',
    'Party',
    'Wedding',
    'Sports',
  ];

  final List<String> weatherList = ['Summer', 'Cold', 'Cool', 'Rainy'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Get Recommendation'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 12),

            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Occasion:',
                      style: AppTextStyles.appTitle.copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedOccasion,
                          isExpanded: true,
                          items: occasions.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedOccasion = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Row(
                  children: [
                    Text(
                      'Weather:',
                      style: AppTextStyles.appTitle.copyWith(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 23,
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedWeather,
                          isExpanded: true,
                          items: weatherList.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedWeather = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Consumer<OpenAIViewModel>(
                  builder: (context, value, child) {
                    return CustomButton(
                      height: MediaQuery.of(context).size.height / 15,
                      width: MediaQuery.of(context).size.width / 1.2,
                      isLoading: value.isLoading,
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        print('--- STARTING RECOMMENDATION ---');
                        await value.getOutfitRecommendation(
                          selectedOccasion,
                          selectedWeather,
                        );
                        print('--- FINISHED RECOMMENDATION ---');
                      },
                      child: Text(
                        'Get Outfit',
                        style: AppTextStyles.appTitle.copyWith(fontSize: 18),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Text(
                  'Recommended Outfit',
                  style: AppTextStyles.appTitle.copyWith(
                    color: Colors.grey.shade900,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 9),
          Consumer<OpenAIViewModel>(
            builder: (context, vm, child) {
              print(vm.recommendedImages.length);

              if (vm.isLoading) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 7,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade200,
                    highlightColor: Colors.grey.shade900,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: 3,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 5,

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            height: MediaQuery.of(context).size.height / 1,

                            decoration: BoxDecoration(
                              border: BoxBorder.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              if (vm.recommendedImages.isEmpty) {
                return Center(
                  child: Text(
                    "No outfit Recommendation Found!",
                    style: AppTextStyles.screenTitle.copyWith(fontSize: 16),
                  ),
                );
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: vm.recommendedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: BoxBorder.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.network(
                          vm.recommendedImages[index],

                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 30),

          Consumer<OpenAIViewModel>(
            builder: (context, vm, child) {
              return CustomButton(
                height: MediaQuery.of(context).size.height / 15,
                width: MediaQuery.of(context).size.width / 1.2,
                onTap: () async {
                  await vm.saveOutfit(selectedOccasion, selectedWeather);

                  FlushbarHelperMessage.showMessage(
                    icon: Icon(Icons.check_circle, color: Colors.white),
                    color: Colors.white,

                    context: context,
                    message: 'Outfit Saved',
                    background: Colors.green,
                  );
                },
                child: vm.isSLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Save Outfit",
                        style: AppTextStyles.appTitle.copyWith(fontSize: 18),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
