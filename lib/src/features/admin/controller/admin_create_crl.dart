import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_reading/src/core/utils/app_strings.dart';
import 'package:e_reading/src/features/admin/model/book_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminCreateCrl extends GetxController {
  BookModel bookModel = BookModel(
    id: '',
    title_ar: '',
    description_ar: '',
    author_ar: '',
    title_en: '',
    description_en: '',
    author_en: '',
    imageUrl: '',
    pdfUrl: '',
    shareLink: '',
    isEnglish: false,
  );

  String imageUrl = '';
  String pdfUrl = '';
  bool isLoading = false;

  String selectedLanguage = 'arabic';

  final List<String> languages = ['arabic', 'english'];

  void setSelectedLanguage(String language) {
    selectedLanguage = language;
    bookModel.isEnglish = language == 'english';
    update();
  }

  void setTitleAr(String newVal) {
    bookModel.title_ar = newVal;
    update();
  }

  void setDescriptionAr(String newVal) {
    bookModel.description_ar = newVal;
    update();
  }

  void setAuthorAr(String newVal) {
    bookModel.author_ar = newVal;
    update();
  }

  void setTitleEn(String newVal) {
    bookModel.title_en = newVal;
    update();
  }

  void setDescriptionEn(String newVal) {
    bookModel.description_en = newVal;
    update();
  }

  void setAuthorEn(String newVal) {
    bookModel.author_en = newVal;
    update();
  }

  void setShareLink(String newVal) {
    bookModel.shareLink = newVal;
    update();
  }

  void setImageUrl(String newVal) {
    imageUrl = newVal;
    bookModel.imageUrl = newVal;
    update();
  }

  void setPdfUrl(String newVal) {
    pdfUrl = newVal;
    bookModel.pdfUrl = newVal;
    update();
  }

  void setIsLoading(bool newVal) {
    isLoading = newVal;
    update();
  }

  void setTitle(String newVal) {
    setTitleAr(newVal);
  }

  void setDescription(String newVal) {
    setDescriptionAr(newVal);
  }

  void setAuthor(String newVal) {
    setAuthorAr(newVal);
  }

  Future<void> addBook(BuildContext context) async {
    bool isValid = true;
    String errorMessage = '';

    // Validate based on selected language
    if (selectedLanguage == 'arabic') {
      if (bookModel.title_ar.isEmpty ||
          bookModel.author_ar.isEmpty ||
          bookModel.description_ar.isEmpty) {
        isValid = false;
        errorMessage = 'يرجى ملء جميع الحقول العربية';
      }
    } else if (selectedLanguage == 'english') {
      if (bookModel.title_en.isEmpty ||
          bookModel.author_en.isEmpty ||
          bookModel.description_en.isEmpty) {
        isValid = false;
        errorMessage = 'يرجى ملء جميع الحقول الإنجليزية';
      }

      // When English is selected, set default empty values for Arabic fields
      if (bookModel.title_ar.isEmpty) bookModel.title_ar = "Default";
      if (bookModel.author_ar.isEmpty) bookModel.author_ar = "Default";
      if (bookModel.description_ar.isEmpty) {
        bookModel.description_ar = "Default";
      }
    }

    // Validate common fields
    if (bookModel.imageUrl.isEmpty || bookModel.pdfUrl.isEmpty) {
      isValid = false;
      errorMessage = 'يرجى توفير روابط للصورة وملف PDF';
    }

    if (!isValid) {
      Get.snackbar(
        'معلومات ناقصة',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    setIsLoading(true);

    try {
      String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (currentUserId.isEmpty) {
        throw Exception('User not logged in');
      }

      bookModel.imageUrl = imageUrl;
      bookModel.pdfUrl = pdfUrl;

      DocumentReference ref =
          FirebaseFirestore.instance.collection(AppStrings.books).doc();

      bookModel.id = ref.id;

      if (bookModel.shareLink.isEmpty) {
        bookModel.shareLink = 'https://ereading.app/books/${bookModel.id}';
      }

      // Set isEnglish based on selected language
      bookModel.isEnglish = selectedLanguage == 'english';

      Map<String, dynamic> bookData = bookModel.toMap();

      await ref.set(bookData);

      clearData();

      Get.back();
      Get.snackbar(
        'تم بنجاح',
        'تمت إضافة الكتاب بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      log('Error adding book: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء إضافة الكتاب: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setIsLoading(false);
    }
  }

  // Clear form data
  void clearData() {
    bookModel = BookModel(
      id: '',
      title_ar: '',
      description_ar: '',
      author_ar: '',
      title_en: '',
      description_en: '',
      author_en: '',
      imageUrl: '',
      pdfUrl: '',
      shareLink: '',
      isEnglish: false,
    );
    imageUrl = '';
    pdfUrl = '';
    selectedLanguage = 'arabic';
    setIsLoading(false);
    update();
  }
}
