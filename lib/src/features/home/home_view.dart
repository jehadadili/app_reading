import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/features/drawer/drawer_view.dart';
import 'package:e_reading/src/features/home/controller/book_controller.dart';
import 'package:e_reading/src/features/home/widgets/book_item_list.dart';
import 'package:e_reading/src/features/home/widgets/search_book.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final BookController bookController = Get.put(BookController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeColor,
      drawer: const DrawerView(),
      appBar: AppBar(
        backgroundColor: AppColors.homeColor,
        elevation: 0,

        title: const Text(
          'E-Reading',
          style: TextStyle(
            fontSize: 25,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (bookController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBook(onChanged: (value) => bookController.search(value)),
              const SizedBox(height: 24),

              Obx(() {
                if (bookController.searchQuery.isNotEmpty &&
                    bookController.searchResults.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Search Results',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 330,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: bookController.searchResults.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: BookItemList(
                                book: bookController.searchResults[index],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              Obx(() {
                if (bookController.selectedType.value != 'all' &&
                    bookController.selectedType.value != 'english' &&
                    bookController.selectedType.value != 'arabic') {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${bookController.selectedType.value.capitalize} Books',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 330,
                        child:
                            bookController.books.isEmpty
                                ? const Center(child: Text('No books found'))
                                : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: bookController.books.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: BookItemList(
                                        book: bookController.books[index],
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ],
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'English Books',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 330,
                      child:
                          bookController.englishBooks.isEmpty
                              ? const Center(
                                child: Text('No English books found'),
                              )
                              : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: bookController.englishBooks.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: BookItemList(
                                      book: bookController.englishBooks[index],
                                    ),
                                  );
                                },
                              ),
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Arabic Books',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 330,
                      child:
                          bookController.arabicBooks.isEmpty
                              ? const Center(
                                child: Text('No Arabic books found'),
                              )
                              : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: bookController.arabicBooks.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: BookItemList(
                                      book: bookController.arabicBooks[index],
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
