import 'package:ai_outfit_recommender/presentation/viewModel/my_wardrobe_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/themes/app_text_styles.dart';
import '../../core/utils/Flushbar_helper.dart';
import '../../data/models/clothing_model.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_container.dart';
import 'outfit_details_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<MyWardrobeViewModel>(context, listen: false).loadOutfits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //---[Custom Appbar]---
      appBar: CustomAppBar(
        title: 'Favorite',
        onTap: () => Navigator.pop(context),
      ),
      body: Consumer<MyWardrobeViewModel>(
        builder: (context, vm, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemCount: vm.outfits.length,
              itemBuilder: (context, index) {
                final data = vm.outfits[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OutfitDetailsScreen(snapshot: data),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      CustomContainer(
                        width: MediaQuery.of(context).size.width,

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //---[Image]---
                            Image.network(
                              data.image,
                              height: 170,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return CircularProgressIndicator(
                                      color: Colors.blue,
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                          ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                          : null,
                                    );
                                  },
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        top: 20,
                        right: 20,
                        child: Row(
                          children: [
                            //---[Favorite Button]---
                            GestureDetector(
                              onTap: () async {
                                _favoriteToggle(vm, data);
                              },
                              child: Icon(
                                data.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: data.isFavorite
                                    ? Colors.red
                                    : Colors.black,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  //---[Favorite Toggle]

  void _favoriteToggle(MyWardrobeViewModel vm, dynamic data) async {
    await vm.toggleFavorite(data.id);
  }
}
