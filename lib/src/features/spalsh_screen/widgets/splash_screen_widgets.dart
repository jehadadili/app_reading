import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/core/widgets/custom_widget_loading.dart';
import 'package:flutter/material.dart';

class SplashScreenWidgets extends StatelessWidget {
  const SplashScreenWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png", color: AppColors.white),
            const SizedBox(height: 50),

            const Text(
              "A World of Books in Your Pocket",
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const CustomWidgetLoading(color: AppColors.white, size: 150),
          ],
        ),
      ),
    );
  }
}
