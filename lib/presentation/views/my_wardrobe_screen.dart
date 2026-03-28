import 'package:ai_outfit_recommender/core/themes/app_text_styles.dart';
import 'package:ai_outfit_recommender/core/utils/Flushbar_helper.dart';
import 'package:ai_outfit_recommender/core/utils/app_routes.dart';
import 'package:ai_outfit_recommender/presentation/viewModel/my_wardrobe_viewModel.dart';
import 'package:ai_outfit_recommender/presentation/views/favorite_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_container.dart';
import 'outfit_details_screen.dart';

class MyWardrobeScreen extends StatefulWidget {
  const MyWardrobeScreen({super.key});

  @override
  State<MyWardrobeScreen> createState() => _MyWardrobeScreenState();
}

class _MyWardrobeScreenState extends State<MyWardrobeScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<MyWardrobeViewModel>(context, listen: false).getOutFitData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //---[Custom Appbar]---
      appBar: CustomAppBar(
        title: 'My Wardrobe',
        onTap: () => Navigator.pop(context),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteScreen()),
              );
            },
            child: Icon(Icons.favorite_border_outlined, color: Colors.white),
          ),
        ],
      ),
      body: Consumer<MyWardrobeViewModel>(
        builder: (context, vm, child) {
          //---[Loading State]
          if (vm.isLoading) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade900,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),

                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                  ),

                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        CustomContainer(
                          width: MediaQuery.of(context).size.width,

                          padding: EdgeInsets.symmetric(vertical: 10),
                        ),

                        Positioned(
                          top: 20,
                          right: 20,
                          child: Row(
                            children: [
                              //---[Delete Button]---
                              Icon(Icons.delete, size: 25),
                              SizedBox(width: 5),

                              //---[Favorite Button]---
                              Icon(Icons.favorite, size: 25),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          }
          //---[Empty state]
          if (vm.outfits.isEmpty) {
            return Center(child: Text("No outfits found"));
          }

          //---[Data Loaded]---
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
                              data.image.toString(),
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
                            //---[Delete Button]---
                            GestureDetector(
                              onTap: () {
                                _showDeleteDialog(index, vm, data.id, context);
                              },

                              child: Icon(Icons.delete, size: 25),
                            ),
                            SizedBox(width: 5),

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

  //---[Delete Dialog Button]
  void _showDeleteDialog(
    int index,
    MyWardrobeViewModel vm,
    String id,
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: Text(
            'This Action Will Remove Item Permanently',
            style: AppTextStyles.appTitle.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.w100,
              fontSize: 16,
            ),
          ),
          content: Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: AppTextStyles.appTitle.copyWith(
                    color: Colors.black87,
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  vm.deleteOutfit(id, index);
                  Navigator.pop(context);
                  FlushbarHelperMessage.showMessage(
                    context: context,
                    message: 'Item Deleted',
                    background: Colors.green,
                    icon: Icon(Icons.check_circle, color: Colors.white),
                    color: Colors.red,
                  );
                },
                child: Text(
                  'Yes',
                  style: AppTextStyles.appTitle.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //---[Favorite Toggle]

  void _favoriteToggle(MyWardrobeViewModel vm, dynamic data) async {
    await vm.toggleFavorite(data.id);
  }
}
