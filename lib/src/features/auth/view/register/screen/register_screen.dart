import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/features/auth/controller/auth_crl.dart';
import 'package:e_reading/src/features/auth/view/login/widgets/email_field.dart';
import 'package:e_reading/src/features/auth/view/login/widgets/password_field.dart';
import 'package:e_reading/src/features/auth/view/register/widgets/confirm_password_field.dart';
import 'package:e_reading/src/features/auth/view/register/widgets/login_link.dart';
import 'package:e_reading/src/features/auth/view/register/widgets/name_fields.dart';
import 'package:e_reading/src/features/auth/view/register/widgets/sign_up_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthCrl>(
      init: AuthCrl(),
      builder: (crl) {
        return Scaffold(
          backgroundColor: AppColors.primary,
          body: Form(
            key: crl.signupFormKey, // لا تستخدم نفس الـ GlobalKey
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                  vertical: MediaQuery.of(context).size.height * 0.05,
                ),
                child: Column(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        double logoSize = constraints.maxWidth * 0.6;
                        return Image.asset(
                          "assets/logo.png",
                          color: AppColors.white,
                          width: logoSize,
                          height: logoSize,
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    NameFields(crl: crl),
                    SizedBox(height: 30),
                    EmailField(crl: crl),
                    SizedBox(height: 30),
                    PasswordField(crl: crl),
                    SizedBox(height: 30),
                    ConfirmPasswordField(crl: crl),
                    SizedBox(height: 50),
                    SignUpButton(crl: crl),
                    SizedBox(height: 20),
                    const LoginLink(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
