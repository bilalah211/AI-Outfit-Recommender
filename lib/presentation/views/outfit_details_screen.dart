import 'package:ai_outfit_recommender/core/themes/app_text_styles.dart';
import 'package:ai_outfit_recommender/data/models/clothing_model.dart';
import 'package:ai_outfit_recommender/presentation/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class OutfitDetailsScreen extends StatefulWidget {
  final ClothingModel snapshot;

  const OutfitDetailsScreen({super.key, required this.snapshot});

  @override
  State<OutfitDetailsScreen> createState() => _OutfitDetailsScreenState();
}

class _OutfitDetailsScreenState extends State<OutfitDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Details'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(widget.snapshot.image),
          Text(
            widget.snapshot.category.toString(),
            style: AppTextStyles.appTitle.copyWith(
              fontSize: 30,
              color: Colors.grey.shade800,
            ),
          ),
          Text(
            widget.snapshot.color.toString(),
            style: AppTextStyles.screenTitle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w100,
              color: Colors.grey.shade800,
            ),
          ),
          Text(
            widget.snapshot.season.toString(),
            style: AppTextStyles.screenTitle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w100,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}
