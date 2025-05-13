import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_reading/src/core/utils/app_strings.dart';
import 'package:e_reading/src/features/admin/model/book_model.dart';
import 'package:get/get.dart';

class AdminCrl extends GetxController {
  CollectionReference get _booksRef =>
      FirebaseFirestore.instance.collection(AppStrings.books);

  List<BookModel> booksList = [];
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    fetchUserBooks();
  }

  void setIsLoading(bool value) {
    isLoading = value;
    update();
  }

  Future<void> fetchUserBooks() async {
    setIsLoading(true);
    booksList.clear();

    try {
      final snapshot =
          await _booksRef.orderBy('timestamp', descending: true).get();

      booksList = snapshot.docs
          .map((doc) => BookModel.fromDocumentSnapshot(doc))
          .toList();

      log("Fetched ${booksList.length} books");
    } catch (e) {
      log("Error fetching books: $e");
    } finally {
      setIsLoading(false);
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await _booksRef.doc(bookId).delete();

      booksList.removeWhere((book) => book.id == bookId);
      update();

      Get.snackbar(
        'تم الحذف',
        'تم حذف الكتاب بنجاح',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      log("Error deleting book: $e");
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء حذف الكتاب',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
