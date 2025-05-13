import 'package:e_reading/src/features/auth/view/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class SignUpHeader extends StatelessWidget {
  const SignUpHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Color(0xff686767),
          ),
          onPressed: () {
            Get.off(LoginScreen());
          },
        ),
        SizedBox(width: 5),
        Text(
          "Create Account",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
