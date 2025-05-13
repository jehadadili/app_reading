import 'package:e_reading/src/core/style/color.dart';
import 'package:flutter/material.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double logoSize = constraints.maxWidth * 0.7;
          return Image.asset(
            "assets/logo.png",
            color: AppColors.background,
            width: logoSize,
            height: logoSize,
          );
        },
      ),
    );
  }
}
