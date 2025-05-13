import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/features/auth/view/forgot_password/view/forgot_password_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Forgot password?",
            style: TextStyle(fontSize: 15, color: AppColors.background),
          ),
          SizedBox(width: 5),
          TextButton(
            onPressed: () {
              Get.to(() => ForgetPasswordPage());
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size(40, 20),
            ),
            child: Text(
              "Reset",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
