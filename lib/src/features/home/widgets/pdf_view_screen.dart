import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String bookTitle;

  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.bookTitle,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localPdfPath;

  bool isLoading = true;

  int? totalPages;

  int? currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  Future<void> loadPdf() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(widget.pdfUrl));
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/temp.pdf');
      await file.writeAsBytes(response.bodyBytes);

      setState(() {
        localPdfPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading PDF: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.bookTitle)),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : localPdfPath == null
              ? const Center(child: Text('Failed to load PDF'))
              : Stack(
                children: [
                  PDFView(
                    filePath: localPdfPath!,
                    enableSwipe: true,
                    swipeHorizontal: false, // ⬅️ التمرير العمودي فقط
                    autoSpacing: true, // ⬅️ مسافة تلقائية بين الصفحات
                    pageFling: true, // ⬅️ تمرير ناعم
                    onRender: (pages) {
                      setState(() {
                        totalPages = pages;
                      });
                    },
                    onViewCreated: (controller) {},
                    onPageChanged: (pageNumber, _) {
                      setState(() {
                        currentPage = pageNumber;
                      });
                    },
                  ),

                  if (currentPage != null && totalPages != null)
                    Positioned(
                      bottom: 20,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.black.withOpacity(0.5),
                        child: Text(
                          'Page ${currentPage! + 1} of $totalPages',
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
    );
  }
}
