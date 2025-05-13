import 'package:e_reading/src/core/style/color.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? Function(String?)? validator;
  final String hintText;
  final double? width;
  final double? height;
  final IconData? suffixIcon;
  final Widget? prefixIcon;
  final String? initialValue;

  final void Function()? onTapSuffixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? prefixText;
  const MyTextField({
    super.key,
    required this.hintText,
    this.width,
    this.height,
    this.suffixIcon,
    required this.validator,
    this.obscureText = false,
    this.onTapSuffixIcon,
    this.onChanged,
    this.keyboardType,
    this.prefixIcon,
    this.prefixText,
    this.controller,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white), // حدود الحقل
        color: AppColors.white,
      ),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        onChanged: onChanged,
        obscureText: obscureText,
        validator: validator,
        style: const TextStyle(
          color: AppColors.blackText, // نص المستخدم
          fontSize: 16,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 10,
          ),
          prefixText: prefixText,
          prefixIcon: prefixIcon,
          suffixIcon:
              suffixIcon != null
                  ? InkWell(
                    onTap: onTapSuffixIcon,
                    child: Icon(
                      suffixIcon,
                      color: AppColors.blackText, // لون الأيقونة
                      size: 20,
                    ),
                  )
                  : null,
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 16,
            
            color: AppColors.hintText, // hint text
            fontWeight: FontWeight.normal,
            
          ),
          
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorStyle: TextStyle(
            fontSize: 10,
            height: 1,
            color: AppColors.error,
          ),
        ),
      ),
    );
  }
}
