
import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/core/widgets/custom_widget_loading.dart';
import 'package:e_reading/src/core/widgets/submit_button.dart';
import 'package:flutter/material.dart';

class ResetButtonWidget extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const ResetButtonWidget({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: isLoading
          ? CustomWidgetLoading(
              color: AppColors.white,
              size: 50,
            )
          : SubmitButton(
              text: "Reset Password",
              onPressed: onPressed,
            ),
    );
  }
}
