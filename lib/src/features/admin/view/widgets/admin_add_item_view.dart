import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/features/admin/view/widgets/book_info_fields.dart';
import 'package:e_reading/src/features/admin/view/widgets/submit_product_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:e_reading/src/features/admin/controller/admin_create_crl.dart';

class AdminAddBookView extends StatelessWidget {
  const AdminAddBookView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminCreateCrl>(
      init: AdminCreateCrl(),
      builder: (createCrl) {
        return Scaffold(
          backgroundColor: AppColors.primary,
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            elevation: 0,
            title: const Text(
              'إضافة كتاب جديد',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: AppColors.primary,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                BookInfoFields(createCrl: createCrl),
                const SizedBox(height: 32),
                SubmitBookButton(createCrl: createCrl),
              ],
            ),
          ),
        );
      },
    );
  }
}
