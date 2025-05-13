// // 📁 lib/models/book_model.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';


// class HomePage extends StatelessWidget {
//   final BookController controller = Get.put(BookController());

//   HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Book Library')),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'English Books',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Obx(
//               () => Column(
//                 children:
//                     controller.englishBooks
//                         .map((book) => BookCard(book))
//                         .toList(),
//               ),
//             ),

//             SizedBox(height: 20),
//             Text(
//               'Arabic Books',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Obx(
//               () => Column(
//                 children:
//                     controller.arabicBooks
//                         .map((book) => BookCard(book))
//                         .toList(),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BookCard extends StatelessWidget {
//   final BookModel book;
//   const BookCard(this.book, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         leading: Image.network(
//           book.imageUrl,
//           width: 50,
//           height: 70,
//           fit: BoxFit.cover,
//         ),
//         title: Text(book.title),
//         subtitle: Text(book.author),
//         onTap: () => Get.to(() => BookDetailsPage(book: book)),
//       ),
//     );
//   }
// }

// class BookDetailsPage extends StatelessWidget {
//   final BookModel book;
//   const BookDetailsPage({super.key, required this.book});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(book.title)),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(child: Image.network(book.imageUrl, height: 200)),
//               SizedBox(height: 10),
//               Text(
//                 book.title,
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               Text('by ${book.author}', style: TextStyle(fontSize: 18)),
//               SizedBox(height: 10),
//               Text(book.description),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.picture_as_pdf),
//                     onPressed:
//                         () async => await launchUrl(Uri.parse(book.pdfUrl)),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.download),
//                     onPressed:
//                         () async => await launchUrl(
//                           Uri.parse(book.pdfUrl),
//                         ), // يمكنك استبداله بتنزيل مباشر
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.share),
//                     onPressed:
//                         () async => await launchUrl(
//                           Uri.parse(
//                             'https://wa.me/?text=${Uri.encodeComponent(book.pdfUrl)}',
//                           ),
//                         ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.favorite_border),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
