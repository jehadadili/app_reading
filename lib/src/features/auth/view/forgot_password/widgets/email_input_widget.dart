import 'package:e_reading/src/core/validator/validater.dart';
import 'package:e_reading/src/core/widgets/my_text_field.dart';
import 'package:flutter/material.dart';

class EmailInputWidget extends StatelessWidget {
  final Function(String) onChanged;

  const EmailInputWidget({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: MyTextField(
        onChanged: onChanged,
        hintText: "Email Address",
        validator: (value) {
          return MyValidator.emailValidator(value);
        },
      ),
    );
  }
}
