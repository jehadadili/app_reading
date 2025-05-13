import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/core/widgets/custom_widget_loading.dart';
import 'package:e_reading/src/core/widgets/submit_button.dart';
import 'package:e_reading/src/features/auth/controller/auth_crl.dart';
import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  final AuthCrl crl;
  const SignUpButton({super.key, required this.crl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child:
          crl.isLoading
              ? Center(
                child: CustomWidgetLoading(color: AppColors.white, size: 50),
              )
              : SubmitButton(
                text: "Sign up",
                onPressed: () {
                  crl.signUp(context);
                },
              ),
    );
  }
}
