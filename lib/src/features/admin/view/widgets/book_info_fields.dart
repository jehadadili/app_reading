import 'package:e_reading/src/core/widgets/my_text_field.dart';
import 'package:e_reading/src/features/admin/controller/admin_create_crl.dart';
import 'package:e_reading/src/features/admin/view/widgets/field_title.dart';
import 'package:flutter/material.dart';

class BookInfoFields extends StatelessWidget {
  final AdminCreateCrl createCrl;

  const BookInfoFields({super.key, required this.createCrl});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldTitle('اختر اللغة'),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: createCrl.selectedLanguage,
                icon: const Icon(Icons.arrow_drop_down),
                style: const TextStyle(color: Colors.black),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    createCrl.setSelectedLanguage(newValue);
                  }
                },
                items:
                    createCrl.languages.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      String displayText = '';
                      switch (value) {
                        case 'arabic':
                          displayText = 'عربي';
                          break;
                        case 'english':
                          displayText = 'إنجليزي';
                          break;
                        default:
                          displayText = value;
                      }
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(displayText),
                      );
                    }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          if (createCrl.selectedLanguage == 'arabic') ...[
            const SectionTitle('معلومات الكتاب بالعربية'),
            const SizedBox(height: 16),

            const FieldTitle('اسم الكتاب بالعربية'),
            MyTextField(
              hintText: 'ادخل اسم الكتاب بالعربية',
              onChanged: createCrl.setTitleAr,
              validator: (_) => null,
            ),
            const SizedBox(height: 16),

            const FieldTitle('المؤلف بالعربية'),
            MyTextField(
              hintText: 'ادخل اسم المؤلف بالعربية',
              onChanged: createCrl.setAuthorAr,
              validator: (_) => null,
            ),
            const SizedBox(height: 16),

            const FieldTitle('وصف الكتاب بالعربية'),
            MyTextField(
              hintText: 'ادخل وصف الكتاب بالعربية',
              onChanged: createCrl.setDescriptionAr,
              validator: (_) => null,
            ),
            const SizedBox(height: 24),
          ],

          // English fields section - visible only if 'english' is selected
          if (createCrl.selectedLanguage == 'english') ...[
            const SectionTitle('معلومات الكتاب بالإنجليزية'),
            const SizedBox(height: 16),

            const FieldTitle('اسم الكتاب بالإنجليزية'),
            MyTextField(
              hintText: 'ادخل اسم الكتاب بالإنجليزية',
              onChanged: createCrl.setTitleEn,
              validator: (_) => null,
            ),
            const SizedBox(height: 16),

            const FieldTitle('المؤلف بالإنجليزية'),
            MyTextField(
              hintText: 'ادخل اسم المؤلف بالإنجليزية',
              onChanged: createCrl.setAuthorEn,
              validator: (_) => null,
            ),
            const SizedBox(height: 16),

            const FieldTitle('وصف الكتاب بالإنجليزية'),
            MyTextField(
              hintText: 'ادخل وصف الكتاب بالإنجليزية',
              onChanged: createCrl.setDescriptionEn,
              validator: (_) => null,
            ),
            const SizedBox(height: 24),
          ],

          // Common fields section - always visible
          const SectionTitle('المعلومات المشتركة'),
          const SizedBox(height: 16),

          const FieldTitle('رابط صورة الكتاب'),
          MyTextField(
            hintText:
                'أدخل رابط صورة الكتاب (يجب أن يبدأ بـ http:// أو https://)',
            onChanged: createCrl.setImageUrl,
            validator: (_) => null,
          ),
          const SizedBox(height: 16),

          const FieldTitle('رابط ملف PDF للكتاب'),
          MyTextField(
            hintText:
                'أدخل رابط ملف PDF للكتاب (يجب أن يبدأ بـ http:// أو https://)',
            onChanged: createCrl.setPdfUrl,
            validator: (_) => null,
          ),
          const SizedBox(height: 16),

          const FieldTitle('رابط المشاركة (اختياري)'),
          MyTextField(
            hintText: 'ادخل رابط المشاركة',
            onChanged: createCrl.setShareLink,
            validator: (_) => null,
          ),
        ],
      ),
    );
  }
}
