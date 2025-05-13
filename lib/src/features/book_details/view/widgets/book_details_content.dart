import 'package:e_reading/src/features/admin/model/book_model.dart';
import 'package:flutter/material.dart';

class BookDetailsContent extends StatelessWidget {
  final BookModel book;

  const BookDetailsContent({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    final bookCoverHeight = screenHeight * 0.35;
    final titleSize = screenWidth > 600 ? 24.0 : 20.0;
    final descriptionSize = screenWidth > 600 ? 16.0 : 14.0;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Book Cover
            Hero(
              tag: 'book_cover_${book.id}',
              child: Container(
                height: bookCoverHeight,
                margin: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    book.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Book Title
            Text(
              book.title,
              style: TextStyle(
                fontSize: titleSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // Author
            Text(
              book.author,
              style: TextStyle(
                fontSize: titleSize * 0.7,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // About the book header
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About the book:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Book description
            Text(
              book.description,
              style: TextStyle(
                fontSize: descriptionSize,
                color: Colors.black87,
                height: 1.5,
              ),
              textAlign: TextAlign.left,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}