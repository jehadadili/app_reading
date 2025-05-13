import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/features/home/controller/book_controller.dart';
import 'package:e_reading/src/features/home/widgets/book_item_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final BookController bookController = Get.find<BookController>();

  @override
  void initState() {
    super.initState();
    // Refresh favorites when screen loads
    bookController.fetchFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeColor,
      appBar: AppBar(
        backgroundColor: AppColors.homeColor,
        elevation: 0,
        title: const Text(
          'My Favorites',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        if (bookController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (bookController.favoriteBooks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Books you add to favorites will appear here',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),

          itemCount: bookController.favoriteBooks.length,
          itemBuilder: (context, index) {
            return BookItemList(book: bookController.favoriteBooks[index]);
          },
        );
      }),
    );
  }
}
