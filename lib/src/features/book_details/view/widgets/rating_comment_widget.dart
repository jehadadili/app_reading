import 'package:e_reading/src/features/book_details/controller/rating_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:e_reading/src/core/widgets/my_text_field.dart';

class RatingCommentWidget extends StatelessWidget {
  final String bookId;

  const RatingCommentWidget({super.key, required this.bookId});

  @override
  Widget build(BuildContext context) {
    final RatingController ratingController = Get.put(RatingController());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rate this book / Write a comment:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Obx(() {
            return RatingBar.builder(
              initialRating: ratingController.currentRating.value,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder:
                  (context, _) => const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                ratingController.currentRating.value = rating;
              },
            );
          }),
          const SizedBox(height: 16),
          MyTextField(
            controller: ratingController.commentController,
            validator: (p0) => null,
            hintText: 'Write a comment (optional if rating)',
          ),
          const SizedBox(height: 16),
          Obx(() {
            return ratingController.isSubmitting.value
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                  onPressed: () => ratingController.submitRating(bookId),
                  child: const Text('Submit'),
                );
          }),
        ],
      ),
    );
  }
}
