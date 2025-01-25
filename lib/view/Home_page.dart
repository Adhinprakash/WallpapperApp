import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dummyproject/app/const/repository.dart';
import 'package:dummyproject/controller/get_images_controller.dart';
import 'package:dummyproject/model/image_model.dart';
import 'package:dummyproject/view/preview_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';


class UserlistView extends StatefulWidget {
  const UserlistView({super.key});

  @override
  State<UserlistView> createState() => _UserlistViewState();
}

class _UserlistViewState extends State<UserlistView> {
  late ScrollController _scrollController;

  final List<String> _categories = [
    "Nature",
    "Technology",
    "Animals",
    "People",
    "Architecture",
    "Abstract",
  ];
  int _selectedCategoryIndex = 0;


  @override
  void initState() {
    super.initState();
    final imagesController = Provider.of<GetImagesController>(context, listen: false);
    imagesController.fetchImages();

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent &&
          !imagesController.isLoading) {
        imagesController.fetchImages(loadMore: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
      toolbarHeight:100,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Column(
          children: [
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Wall-',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                      fontSize: 22),
                ),
                Text(
                  'E',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                      fontSize: 22),
                ),
              ],
              
            ),
            const SizedBox(height: 15),
          Consumer<GetImagesController>(
              builder: (context, controller, child) {
                return SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = controller.selectedCategory == _categories[index];
                      return GestureDetector(
                        onTap: () {
                          controller.fetchImagesByCategory(_categories[index]);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Chip(
                            label: Text(
                              _categories[index],
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.grey[400],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor: isSelected ? Colors.blue : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Consumer<GetImagesController>(
        builder: (context, controller, child) {
          if (controller.isLoading && controller.images.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
      
          if (controller.images.isEmpty) {
            return const Center(child: Text("No images found"));
          }
      
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9,vertical: 10),
            child: ClipRRect(
               borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), 
          topRight: Radius.circular(20), 
        ),
              child: Container(
               color: Colors.white,
                child: MasonryGridView.count(
                  controller: _scrollController,
                  itemCount: controller.images.length + (controller.isLoading ? 1 : 0),
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  itemBuilder: (context, index) {
                    if (index == controller.images.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                
                    final image = controller.images[index];
                    double height = (index % 10 + 1) * 100;
                
                    return GestureDetector( 
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PreviewPage(imageId: image.imageID, imageUrl: image.imagePotraitPath),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: height > 300 ? 300 : height,
                          imageUrl: image.imagePotraitPath,
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
