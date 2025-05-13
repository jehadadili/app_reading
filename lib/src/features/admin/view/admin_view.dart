import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/features/admin/controller/admin_crl.dart';
import 'package:e_reading/src/features/admin/view/widgets/admin_add_item_view.dart';
import 'package:e_reading/src/features/admin/view/widgets/book_comments_view.dart';
import 'package:e_reading/src/features/admin/view/widgets/custom_design.dart';
import 'package:e_reading/src/features/admin/view/widgets/custom_my_container.dart'; // Ensure this path is correct
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AdminCrl());

    return GetBuilder<AdminCrl>(
      builder: (admincrl) {
        if (admincrl.isLoading && admincrl.booksList.isEmpty) {
          return const Scaffold(
            backgroundColor: Color(0xff00091e),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.primary,
          body: Column(
            children: [
              const SizedBox(height: 50),
              const CustomDesign(),
              Expanded(
                child: admincrl.booksList.isEmpty
                    ? const Center(
                        child: Text(
                          "لا يوجد كتب حالياً",
                          style: TextStyle(color: AppColors.white),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => admincrl.fetchUserBooks(),
                        child: ListView.builder(
                          itemCount: admincrl.booksList.length,
                          itemBuilder: (context, index) {
                            final book = admincrl.booksList[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 16.0,
                              ),
                              child: CustomBookContainer(
                                book: book, 
                                onPressedDelete: () => admincrl.deleteBook(book.id),
                                onViewComments: (bookId, bookTitle) {
                                  Get.to(() => BookCommentsView(bookId: bookId, bookTitle: bookTitle));
                                },
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await Get.to(() => const AdminAddBookView());
              
            },
            backgroundColor: AppColors.error,
            tooltip: 'إضافة كتاب جديد',
            child: const Icon(Icons.add, color: Colors.white, size: 30),
          ),
        );
      },
    );
  }
}

