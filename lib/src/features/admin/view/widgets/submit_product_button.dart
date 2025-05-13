import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/core/widgets/submit_button.dart';
import 'package:e_reading/src/features/admin/controller/admin_create_crl.dart';
import 'package:flutter/material.dart';

class SubmitBookButton extends StatelessWidget {
  final AdminCreateCrl createCrl;

  const SubmitBookButton({super.key, required this.createCrl});

  @override
  Widget build(BuildContext context) {
    return createCrl.isLoading
        ? const CircularProgressIndicator(color: AppColors.primary)
        : SubmitButton(
          text: 'حفظ الكتاب',
          onPressed: () => createCrl.addBook(context),
        );
  }
}
