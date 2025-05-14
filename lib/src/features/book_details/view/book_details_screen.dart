import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_reading/src/features/admin/model/book_model.dart';
import 'package:e_reading/src/features/book_details/model/rating_model.dart';
import 'package:e_reading/src/features/book_details/view/widgets/book_actions_bar.dart';
import 'package:e_reading/src/features/book_details/view/widgets/book_details_content.dart';
import 'package:e_reading/src/features/book_details/view/widgets/download_manager.dart';
import 'package:e_reading/src/features/book_details/view/widgets/rating_comment_widget.dart';
import 'package:e_reading/src/features/book_details/view/widgets/share_options_sheet.dart';

import 'package:e_reading/src/features/home/controller/book_controller.dart';
import 'package:e_reading/src/features/home/widgets/pdf_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookDetailsScreen extends StatefulWidget {
  final BookModel book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final BookController bookController = Get.find<BookController>();
  final DownloadManager _downloadManager = DownloadManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8D7D3),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        // Changed to SingleChildScrollView to accommodate more content
        child: Column(
          children: [
            BookDetailsContent(book: widget.book),
            BookActionsBar(
              book: widget.book,
              bookController: bookController,
              downloadManager: _downloadManager,
              onShare: () => _showShareOptions(context),
              onRead: () => _openPdfViewer(context),
              onDownload: () => _downloadBook(context),
            ),
            const Divider(height: 20, thickness: 1),
            RatingCommentWidget(
              bookId: widget.book.id,
            ), // Added RatingCommentWidget
            const Divider(height: 20, thickness: 1),
            _buildRatingsList(), // Added to display existing ratings
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFE8D7D3),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Book Details',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildRatingsList() {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('book_ratings')
              .where('bookId', isEqualTo: widget.book.id)
              .orderBy('timestamp', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No ratings yet. Be the first to rate!'),
          );
        }

        final ratings =
            snapshot.data!.docs
                .map(
                  (doc) => RatingModel.fromMap(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  ),
                )
                .toList();

        return ListView.builder(
          shrinkWrap:
              true, // Important for ListView inside SingleChildScrollView
          physics:
              const NeverScrollableScrollPhysics(), // Disable scrolling for this ListView
          itemCount: ratings.length,
          itemBuilder: (context, index) {
            final rating = ratings[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          rating.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Basic star display, replace with flutter_rating_bar if available
                        Row(
                          children: List.generate(5, (i) {
                            return Icon(
                              i < rating.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(rating.comment),
                    const SizedBox(height: 4),
                    Text(
                      // Format timestamp to a readable string
                      '${rating.timestamp.toDate().day}/${rating.timestamp.toDate().month}/${rating.timestamp.toDate().year}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openPdfViewer(BuildContext context) {
    if (widget.book.pdfUrl.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => PdfViewerScreen(
                pdfUrl: widget.book.pdfUrl,
                bookTitle: widget.book.title,
              ),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('PDF is not available')));
    }
  }

  void _showShareOptions(BuildContext context) {
    final shareText =
        widget.book.shareLink.isNotEmpty
            ? 'Check out this book: ${widget.book.title} by ${widget.book.author}\n${widget.book.shareLink}'
            : 'Check out this book: ${widget.book.title} by ${widget.book.author}';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return ShareOptionsSheet(book: widget.book, shareText: shareText);
      },
    );
  }

  Future<void> _downloadBook(BuildContext context) async {
    if (widget.book.pdfUrl.isEmpty) {
      Get.snackbar(
        'Error',
        'PDF URL is not available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // تصحيح الخطأ هنا: إزالة الشرطة المائلة الزائدة قبل علامة الاقتباس الأخيرة
    final fileName =
        '${widget.book.title.replaceAll(RegExp(r'[^\w\s]+'), '')}.pdf';

    _downloadManager.startDownload(
      context: context,
      fileUrl: widget.book.pdfUrl,
      fileName: fileName,
      onProgress: (progress) {
        setState(() {}); // Trigger rebuild to update UI
      },
    );
  }
}
