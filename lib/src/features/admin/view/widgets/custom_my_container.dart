import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/features/admin/model/book_model.dart'; 
import 'package:flutter/material.dart';

class CustomBookContainer extends StatelessWidget {
  const CustomBookContainer({
    super.key,
    required this.book, 
    this.onPressedDelete,
    this.onViewComments, 
  });

  final BookModel book;
  final void Function()? onPressedDelete;
  final void Function(String bookId, String bookTitle)? onViewComments;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book cover image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                book.imageUrl,
                width: screenWidth * 0.25, // Adjusted size
                height: screenWidth * 0.3,  // Adjusted size
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: screenWidth * 0.25,
                    height: screenWidth * 0.3,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 40),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.title,
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 20 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          book.author,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: screenWidth > 600 ? 14 : 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    book.description,
                    style: TextStyle(
                      color: AppColors.blackText.withOpacity(0.7),
                      fontSize: screenWidth > 600 ? 14 : 12,
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 2, // Show more description if possible
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  // Average Rating Display
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber[700], size: 16),
                      const SizedBox(width: 4),
                      Text(
                        book.averageRating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${book.ratingCount} ratings)',
                        style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (onViewComments != null)
                        TextButton.icon(
                          icon: const Icon(Icons.comment, size: 16, color: AppColors.primary), // Use a color from your theme
                          label: const Text('View Comments', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                          onPressed: () => onViewComments!(book.id, book.title),
                           style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(50, 30), 
                          ),
                        ),
                      const Spacer(),
                      if (onPressedDelete != null)
                        IconButton(
                          onPressed: onPressedDelete,
                          icon: const Icon(Icons.delete, color: AppColors.error),
                          iconSize: 20, // Adjust size
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(), // Remove extra padding
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
