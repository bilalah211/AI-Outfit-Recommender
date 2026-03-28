import 'package:ai_outfit_recommender/data/models/outfit_recommendation_model.dart';
import 'package:ai_outfit_recommender/data/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/themes/app_text_styles.dart';
import '../../core/utils/helper.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_container.dart';

class SavedOutFitScreen extends StatefulWidget {
  const SavedOutFitScreen({super.key});

  @override
  State<SavedOutFitScreen> createState() => _SavedOutFitScreenState();
}

class _SavedOutFitScreenState extends State<SavedOutFitScreen> {
  final List<String> _images = [
    'assets/outfits/pantt.png',
    'assets/outfits/shirt.png',
    'assets/outfits/shirt.png',
    'assets/outfits/pantt.png',
    'assets/outfits/shirt.png',
    'assets/outfits/pantt.png',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Saved Outfits',
        actions: [Icon(Icons.favorite_border, color: Colors.white)],
      ),
      body: StreamBuilder<List<OutfitRecommendationModel>>(
        stream: context.read<FirebaseServices>().getRecommendedOutfits(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.delete_outline),
                            SizedBox(width: 5),
                            Icon(Icons.favorite_border),
                          ],
                        ),
                        Divider(),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),

                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                          itemCount: 3,

                          itemBuilder: (context, i) {
                            return CustomContainer();
                          },
                        ),

                        Divider(),
                        Align(
                          alignment: Alignment.center,
                          child: CustomButton(
                            height: MediaQuery.of(context).size.height / 18,
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              'View',
                              style: AppTextStyles.appTitle.copyWith(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No saved outfits"));
          }

          final outfits = snapshot.data!;
          return ListView.builder(
            itemCount: outfits.length,
            itemBuilder: (context, index) {
              final outfit = outfits[index];

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          outfit.occasion,
                          style: AppTextStyles.appTitle.copyWith(
                            fontSize: 20,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.delete_outline),
                        SizedBox(width: 5),
                        Icon(Icons.favorite_border),
                      ],
                    ),
                    Divider(),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),

                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: outfit.imageUrls.length,

                      itemBuilder: (context, i) {
                        return CustomContainer(
                          child: Image.network(
                            outfit.imageUrls[i],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),

                    Divider(),
                    Align(
                      alignment: Alignment.center,
                      child: CustomButton(
                        height: MediaQuery.of(context).size.height / 18,
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          'View',
                          style: AppTextStyles.appTitle.copyWith(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
