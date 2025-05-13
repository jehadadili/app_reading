import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_reading/src/features/book_details/model/rating_model.dart';
import 'package:e_reading/src/features/admin/model/book_model.dart';
import 'package:e_reading/src/features/auth/controller/auth_crl.dart';

class RatingController extends GetxController {
  final AuthCrl _authCrl = Get.find<AuthCrl>();
  RxDouble currentRating = 0.0.obs;
  TextEditingController commentController = TextEditingController();
  RxBool isSubmitting = false.obs;
  
  // إضافة RxList لتخزين التقييمات
  RxList<RatingModel> ratings = <RatingModel>[].obs;

  // الدالة الخاصة بإرسال التقييم
  Future<void> submitRating(String bookId) async {
    if (currentRating.value == 0.0 && commentController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a rating or write a comment.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSubmitting.value = true;

    final user = _authCrl.userModel;
    if (user.id.isEmpty) {
      Get.snackbar(
        'Error',
        'You must be logged in to submit a rating/comment.',
        snackPosition: SnackPosition.BOTTOM,
      );
      isSubmitting.value = false;
      return;
    }

    final ratingId = FirebaseFirestore.instance.collection('book_ratings').doc().id;
    final newRating = RatingModel(
      id: ratingId,
      userId: user.id,
      userName: user.username.isNotEmpty ? user.username : 'Anonymous User',
      bookId: bookId,
      rating: currentRating.value,
      comment: commentController.text,
      timestamp: Timestamp.now(),
    );

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference bookDocRef = FirebaseFirestore.instance.collection('books').doc(bookId);
        DocumentSnapshot bookSnapshot = await transaction.get(bookDocRef);

        if (!bookSnapshot.exists) {
          throw Exception("Book not found!");
        }

        DocumentReference ratingDocRef = FirebaseFirestore.instance.collection('book_ratings').doc(ratingId);
        transaction.set(ratingDocRef, newRating.toMap());

        if (currentRating.value > 0) {
          BookModel book = BookModel.fromMap(bookSnapshot.data() as Map<String, dynamic>);
          double totalRatingSum = book.averageRating * book.ratingCount;
          int newRatingCount = book.ratingCount + 1;
          double newAverageRating = (totalRatingSum + currentRating.value) / newRatingCount;

          transaction.update(bookDocRef, {
            'averageRating': newAverageRating,
            'ratingCount': newRatingCount,
          });
        }
      });

      // إضافة التقييم الجديد إلى القائمة التفاعلية مباشرة
      ratings.add(newRating);

      Get.snackbar(
        'Success',
        'Your submission has been recorded.',
        snackPosition: SnackPosition.BOTTOM,
      );
      commentController.clear();
      currentRating.value = 0.0;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}
