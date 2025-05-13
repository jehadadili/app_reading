import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/features/admin/model/book_model.dart';
import 'package:e_reading/src/features/book_details/view/widgets/action_button.dart';
import 'package:e_reading/src/features/book_details/view/widgets/download_manager.dart';
import 'package:e_reading/src/features/home/controller/book_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class BookActionsBar extends StatelessWidget {
  final BookModel book;
  final BookController bookController;
  final DownloadManager downloadManager;
  final VoidCallback onShare;
  final VoidCallback onRead;
  final VoidCallback onDownload;

  const BookActionsBar({
    super.key,
    required this.book,
    required this.bookController,
    required this.downloadManager,
    required this.onShare,
    required this.onRead,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final isDownloading = downloadManager.isDownloading;
    final downloadProgress = downloadManager.downloadProgress;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isDownloading)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: downloadProgress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
                const SizedBox(height: 8),
                Text(
                  'Downloading: ${(downloadProgress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFE8D7D3),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Share Button
              ActionButton(
                icon: FontAwesomeIcons.share,
                label: 'Share',
                onTap: onShare,
              ),

              // Read Button
              ActionButton(
                icon: FontAwesomeIcons.bookOpen,
                label: 'Read',
                onTap: onRead,
              ),

              // Download Button
              ActionButton(
                icon: FontAwesomeIcons.download,
                label: 'Download',
                onTap: isDownloading ? null : onDownload,
                isDisabled: isDownloading,
              ),

              // Favorite Button
              Obx(() {
                final isFavorite = bookController.isFavorite(book.id);
                return ActionButton(
                  icon: isFavorite ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
                  label: 'Favorite',
                  onTap: () => bookController.toggleFavorite(book),
                  iconColor: isFavorite ? Colors.red : null,
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
