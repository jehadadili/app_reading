import 'package:e_reading/src/core/validator/validater.dart';
import 'package:e_reading/src/core/widgets/my_text_field.dart';
import 'package:e_reading/src/features/auth/controller/auth_crl.dart';
import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final AuthCrl crl;
  const EmailField({required this.crl, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        MyTextField(
          hintText: "Email Address",
          keyboardType: TextInputType.emailAddress,
          onChanged: (newVal) {
            crl.setEmail(newVal);
          },
          validator: (email) {
            return MyValidator.emailValidator(email);
          },
        ),
      ],
    );
  }
}
