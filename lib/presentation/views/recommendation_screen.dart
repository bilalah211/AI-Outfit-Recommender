import 'package:ai_outfit_recommender/presentation/viewModel/openAI_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/themes/app_text_styles.dart';
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
    final vm = Provider.of<OpenAIViewModel>(context, listen: false);
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
                Consumer(
                  builder: (context, value, child) {
                    return CustomButton(
                      height: MediaQuery.of(context).size.height / 15,
                      width: MediaQuery.of(context).size.width / 1.2,
                      child: Text(
                        'Get Outfit',
                        style: AppTextStyles.appTitle.copyWith(fontSize: 18),
                      ),
                      onTap: () async {
                        print('BUTTON CLICKED');
                        await vm.getOutfitRecommendation(
                          selectedOccasion,
                          selectedWeather,
                        );
                      },
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
                return Center(child: CircularProgressIndicator());
              }

              if (vm.recommendedImages.isEmpty) {
                return Center(child: Text("No outfit found"));
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height / 2.8,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: vm.recommendedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        vm.recommendedImages[index],
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              );
            },
          ),
          SizedBox(height: 25),

          Consumer<OpenAIViewModel>(
            builder: (context, vm, child) {
              return CustomButton(
                height: MediaQuery.of(context).size.height / 15,
                width: MediaQuery.of(context).size.width / 1.2,
                onTap: vm.recommendedImages.isEmpty
                    ? null
                    : () async {
                        await vm.saveOutfit(selectedOccasion, selectedWeather);

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text("Outfit Saved")));
                      },
                child: vm.isSLoading
                    ? CircularProgressIndicator()
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
