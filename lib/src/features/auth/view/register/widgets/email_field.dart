import 'package:e_reading/src/core/validator/validater.dart';
import 'package:e_reading/src/core/widgets/my_text_field.dart';
import 'package:e_reading/src/features/auth/controller/auth_crl.dart';
import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final AuthCrl crl;
  const EmailField({super.key, required this.crl});

  @override
  Widget build(BuildContext context) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          "Email",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
          SizedBox(height: 8),
        MyTextField(
          keyboardType: TextInputType.emailAddress,
          hintText: "Email Address",
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
