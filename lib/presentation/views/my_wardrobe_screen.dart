import 'package:ai_outfit_recommender/core/utils/app_routes.dart';
import 'package:ai_outfit_recommender/data/models/clothing_model.dart';
import 'package:ai_outfit_recommender/presentation/viewModel/my_wardrobe_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_container.dart';
import 'outfit_details_screen.dart';

class MyWardrobeScreen extends StatefulWidget {
  const MyWardrobeScreen({super.key});

  @override
  State<MyWardrobeScreen> createState() => _MyWardrobeScreenState();
}

class _MyWardrobeScreenState extends State<MyWardrobeScreen> {
  late Future<List<ClothingModel>> _future;

  @override
  void initState() {
    _future = _loadData();
    super.initState();
  }

  //---[Function to Load Data]---
  Future<List<ClothingModel>> _loadData() async {
    final vm = Provider.of<MyWardrobeViewModel>(context, listen: false);

    return vm.getOutFitData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //---[Custom Appbar]---
      appBar: CustomAppBar(
        title: 'My Wardrobe',
        onTap: () => Navigator.pop(context),
        actions: [Icon(Icons.favorite_border_outlined, color: Colors.white)],
      ),
      body: FutureBuilder<List<ClothingModel>>(
        future: _future,
        builder: (context, snapshot) {
          //---[Loading State]---

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          //---[Error State]---

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          //---[No Data Found]---

          if (!snapshot.hasData) {
            return Center(child: Text('No Data Found'));
          }
          //---[Show Data in GridView]---

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),

            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final data = snapshot.data![index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OutfitDetailsScreen(snapshot: snapshot.data![index]),
                    ),
                  );
                },
                child: Stack(
                  children: [
                    CustomContainer(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          //---[Image]---
                          Image.network(
                            data.image,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Provider.of<MyWardrobeViewModel>(
                                context,
                                listen: false,
                              ).deleteOutfit(snapshot.data![index].id);
                              _loadData();
                            },

                            child: Icon(Icons.delete, size: 25),
                          ),
                          SizedBox(width: 5),
                          GestureDetector(
                            onTap: () async {
                              await Provider.of<MyWardrobeViewModel>(
                                context,
                                listen: false,
                              ).toggleFavorite(data.id, data.isFavorite);
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
          );
        },
      ),
    );
  }
}
