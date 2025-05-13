import 'package:e_reading/src/core/validator/validater.dart';
import 'package:e_reading/src/core/widgets/my_text_field.dart';
import 'package:e_reading/src/features/auth/controller/auth_crl.dart';
import 'package:flutter/material.dart';

class ConfirmPasswordField extends StatelessWidget {
  final AuthCrl crl;
  const ConfirmPasswordField({super.key, required this.crl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Confirm Password",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        MyTextField(
          keyboardType: TextInputType.visiblePassword,
          obscureText: crl.isVisable,
          hintText: "Confirm Password",
          onChanged: (newVal) {
            crl.setCPassword(newVal);
          },
          validator: (password) {
            return MyValidator.passwrdValidator(password);
          },

          onTapSuffixIcon: () {
            crl.setIsVisable();
          },
          suffixIcon: crl.isVisable ? Icons.visibility_off : Icons.visibility,
        ),
      ],
    );
  }
}
