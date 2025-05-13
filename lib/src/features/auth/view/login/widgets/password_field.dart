import 'package:e_reading/src/core/validator/validater.dart';
import 'package:e_reading/src/core/widgets/my_text_field.dart';
import 'package:e_reading/src/features/auth/controller/auth_crl.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final AuthCrl crl;
  const PasswordField({required this.crl, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Password",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        MyTextField(
          obscureText: crl.isVisable,
          keyboardType: TextInputType.visiblePassword,
          hintText: "Password",
          suffixIcon: crl.isVisable ? Icons.visibility_off : Icons.visibility,
          onTapSuffixIcon: () {
            crl.setIsVisable();
          },
          onChanged: (newVal) {
            crl.setPassword(newVal);
          },
          validator: (password) {
            return MyValidator.passwrdValidator(password);
          },
        ),
      ],
    );
  }
}
