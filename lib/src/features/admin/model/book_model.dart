import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  String id;
  String title_ar;
  String author_ar;
  String description_ar;
  String title_en;
  String author_en;
  String description_en;
  String imageUrl;
  String pdfUrl;
  String shareLink;
  bool isEnglish;
  double averageRating; 
  int ratingCount;     
  
  BookModel({
    required this.id,
    required this.title_ar,
    required this.author_ar,
    required this.description_ar,
    this.title_en = '',
    this.author_en = '',
    this.description_en = '',
    required this.imageUrl,
    required this.pdfUrl,
    this.shareLink = '',
    this.isEnglish = false,
    this.averageRating = 0.0, // Default value
    this.ratingCount = 0,     // Default value
  });

  // For backward compatibility with existing code
  String get title => isEnglish ? title_en : title_ar;
  String get author => isEnglish ? author_en : author_ar;
  String get description => isEnglish ? description_en : description_ar;

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      id: map['id'] ?? '',
      title_ar: map['title_ar'] ?? map['title'] ?? '',  // Backward compatibility
      author_ar: map['author_ar'] ?? map['author'] ?? '',
      description_ar: map['description_ar'] ?? map['description'] ?? '',
      title_en: map['title_en'] ?? '',
      author_en: map['author_en'] ?? '',
      description_en: map['description_en'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      pdfUrl: map['pdfUrl'] ?? '',
      shareLink: map['shareLink'] ?? '',
      isEnglish: map['isEnglish'] ?? false,
      averageRating: (map['averageRating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: map['ratingCount'] as int? ?? 0,
    );
  }
  
  // From DocumentSnapshot
  factory BookModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BookModel(
      id: doc.id,
      title_ar: data['title_ar'] ?? data['title'] ?? '',  // Backward compatibility
      author_ar: data['author_ar'] ?? data['author'] ?? '',
      description_ar: data['description_ar'] ?? data['description'] ?? '',
      title_en: data['title_en'] ?? '',
      author_en: data['author_en'] ?? '',
      description_en: data['description_en'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      pdfUrl: data['pdfUrl'] ?? '',
      shareLink: data['shareLink'] ?? '',
      isEnglish: data['isEnglish'] ?? false,
      averageRating: (data['averageRating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: data['ratingCount'] as int? ?? 0,
    );
  }
  
  // Convert to map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title_ar': title_ar,
      'author_ar': author_ar,
      'description_ar': description_ar,
      'title_en': title_en,
      'author_en': author_en,
      'description_en': description_en,
      'imageUrl': imageUrl,
      'pdfUrl': pdfUrl,
      'shareLink': shareLink,
      'isEnglish': isEnglish,
      'averageRating': averageRating,
      'ratingCount': ratingCount,
      'timestamp': FieldValue.serverTimestamp(), // Use server timestamp for consistency
    };
  }
}

