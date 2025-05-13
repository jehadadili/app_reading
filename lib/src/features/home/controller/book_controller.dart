import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_reading/src/core/utils/app_strings.dart';
import 'package:e_reading/src/features/admin/model/book_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class BookController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<BookModel> _books = <BookModel>[].obs;
  final RxList<BookModel> _favoriteBooks = <BookModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingFavorites = false.obs; // Separate loading for favorites
  final RxString searchQuery = ''.obs;
  final RxString selectedType = 'all'.obs;

  // Stream subscription for books
  Stream<QuerySnapshot>? _booksStream;
  var _booksListener;

  List<BookModel> get books => _books;
  List<BookModel> get favoriteBooks => _favoriteBooks;

  List<BookModel> get englishBooks =>
      _books.where((book) => book.isEnglish).toList();

  List<BookModel> get arabicBooks =>
      _books.where((book) => !book.isEnglish).toList();

  List<BookModel> get filteredBooks {
    switch (selectedType.value) {
      case 'english':
        return englishBooks;
      case 'arabic':
        return arabicBooks;
      case 'favorites':
        return favoriteBooks;
      case 'all':
      default:
        return _books;
    }
  }

  List<BookModel> get searchResults {
    if (searchQuery.isEmpty) return [];
    final query = searchQuery.value.toLowerCase();
    return _books.where((book) {
      return book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _initBooksStream(); // Initialize the books stream
    fetchFavorites(); // Favorites can still be fetched, or also streamed if needed
  }

  void _initBooksStream() {
    isLoading.value = true;
    _booksStream =
        _firestore
            .collection(AppStrings.books)
            .orderBy('timestamp', descending: true)
            .snapshots();

    _booksListener = _booksStream?.listen(
      (snapshot) {
        _books.value =
            snapshot.docs
                .map((doc) => BookModel.fromDocumentSnapshot(doc))
                .toList();
        log('Books updated from stream: ${_books.length} books');
        isLoading.value = false;
      },
      onError: (error) {
        log('Error listening to books stream: $error');
        isLoading.value = false;
      },
    );
  }

  // Call this method if you need to manually refresh or re-fetch books,
  // though the stream should handle most updates.
  Future<void> refreshBooks() async {
    // If not using a stream, this would be the place to re-fetch.
    // With a stream, this might not be strictly necessary unless you want to force a re-read for some reason.
    // For now, the stream handles updates. If a manual refresh is needed, we can implement it.
    // For example, if filters change that are not part of the Firestore query.
    // However, the current stream is for *all* books, sorted.
    // If fetchBooks was called from elsewhere, ensure it's compatible with stream logic.
    // The `RatingCommentWidget` calls `bookController.fetchBooks()`.
    // We can rename this to `refreshBooks` and have it do nothing if the stream is active,
    // or re-initialize the stream if necessary.
    // For now, let's assume the stream is sufficient and the call from RatingCommentWidget
    // might not be needed or should be re-evaluated.
    log(
      "refreshBooks called. Stream is active, so data should update automatically.",
    );
    // If you truly need to re-fetch (e.g., after a major data import not caught by stream immediately):
    // _booksListener?.cancel(); // Cancel existing listener
    // _initBooksStream(); // Re-initialize
  }

  void filterBooksByType(String type) {
    selectedType.value = type;
  }

  void search(String query) {
    searchQuery.value = query;
  }

  Future<void> fetchFavorites() async {
    // if (_books.isEmpty) { // This check might be problematic if books are streamed
    //   // await fetchBooks(); // This would be the old way
    // }

    isLoadingFavorites.value = true;
    final currentUser = _auth.currentUser;

    if (currentUser == null) {
      _favoriteBooks.clear();
      isLoadingFavorites.value = false;
      return;
    }

    try {
      final userFavoritesRef = _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('favorites');

      // Favorites can also be streamed if real-time updates are needed for them too
      final snapshot = await userFavoritesRef.get();
      final favoriteIds = snapshot.docs.map((doc) => doc.id).toList();

      if (favoriteIds.isEmpty) {
        _favoriteBooks.clear();
      } else {
        // This part might be inefficient if favoriteIds is very large.
        // Consider structuring data differently or fetching favorite books individually if needed.
        final bookDocs =
            await _firestore
                .collection(AppStrings.books)
                .where(FieldPath.documentId, whereIn: favoriteIds)
                .get();

        _favoriteBooks.value =
            bookDocs.docs
                .map((doc) => BookModel.fromDocumentSnapshot(doc))
                .toList();
      }
      log("Fetched ${_favoriteBooks.length} favorite books");
    } catch (e) {
      log('Error fetching favorites: $e');
    } finally {
      isLoadingFavorites.value = false;
    }
  }

  bool isFavorite(String bookId) {
    return _favoriteBooks.any((book) => book.id == bookId);
  }

  Future<void> toggleFavorite(BookModel book) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      Get.snackbar(
        'Not logged in',
        'Please login to add favorites',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final userFavoritesRef = _firestore
        .collection('users')
        .doc(currentUser.uid)
        .collection('favorites');

    try {
      if (isFavorite(book.id)) {
        await userFavoritesRef.doc(book.id).delete();
        _favoriteBooks.removeWhere((item) => item.id == book.id);
        Get.snackbar(
          'Removed',
          'Book removed from favorites',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        await userFavoritesRef.doc(book.id).set({
          'timestamp':
              FieldValue.serverTimestamp(), // Good practice to timestamp favorite actions
        });
        // To ensure the BookModel in _favoriteBooks has all details, fetch it if not already present
        // or rely on the structure that `book` parameter is already a complete BookModel.
        if (!_favoriteBooks.any((b) => b.id == book.id)) {
          _favoriteBooks.add(book); // Add the passed book model
        }
        Get.snackbar(
          'Added',
          'Book added to favorites',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      log('Error toggling favorite: $e');
      Get.snackbar(
        'Error',
        'Could not update favorites',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  void onClose() {
    _booksListener
        ?.cancel(); // Cancel the stream listener when controller is closed
    super.onClose();
  }
}
