import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/features/auth/controller/auth_crl.dart';
import 'package:e_reading/src/features/auth/view/forgot_password/widgets/email_input_widget.dart';
import 'package:e_reading/src/features/auth/view/forgot_password/widgets/logo_section.dart';
import 'package:e_reading/src/features/auth/view/forgot_password/widgets/reset_button_widget.dart';
import 'package:e_reading/src/features/auth/view/forgot_password/widgets/text_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthCrl>(
      init: AuthCrl(),
      builder: (crl) {
        return Scaffold(
          backgroundColor: AppColors.primary,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.06,
                  horizontal: MediaQuery.of(context).size.width * 0.08,
                ),
                child: Form(
                  key: crl.forgotPasswordKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextSection(),
                      const SizedBox(height: 10),
                      const LogoSection(),
                      const SizedBox(height: 10),
                      const Text(
                        "Enter Your Email Address",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      EmailInputWidget(
                        onChanged: (newVal) {
                          crl.setEmail(newVal);
                        },
                      ),
                      const SizedBox(height: 40),
                      ResetButtonWidget(
                        isLoading: crl.isLoading,
                        onPressed: () async {
                          bool success = await crl.resetPassword(context);
                          if (success) {
                            Get.snackbar(
                              "Success",
                              "Password reset email sent. Please check your email.",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
