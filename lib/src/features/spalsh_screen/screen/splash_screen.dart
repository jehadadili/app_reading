import 'package:e_reading/src/features/pages_start/init_start_view.dart';
import 'package:e_reading/src/features/spalsh_screen/widgets/splash_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (mounted) {
        Get.to(InitStartView());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreenWidgets();
  }
}
