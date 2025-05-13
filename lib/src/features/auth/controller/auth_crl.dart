import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_reading/src/core/utils/app_strings.dart';
import 'package:e_reading/src/core/utils/my_aleart_dialog.dart';
import 'package:e_reading/src/features/admin/view/admin_view.dart';
import 'package:e_reading/src/features/auth/model/user_model.dart';
import 'package:e_reading/src/features/auth/view/login/screen/login_screen.dart';
import 'package:e_reading/src/features/home/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthCrl extends GetxController {
  // Create new keys for each form instance
  // These will be recreated when needed instead of being reused
  GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _forgotPasswordKey = GlobalKey<FormState>();
  GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  // Getters for the form keys
  GlobalKey<FormState> get loginFormKey => _loginFormKey;
  GlobalKey<FormState> get forgotPasswordKey => _forgotPasswordKey;
  GlobalKey<FormState> get signupFormKey => _signupFormKey;

  // Method to reset keys when navigating between forms
  void resetFormKeys() {
    _loginFormKey = GlobalKey<FormState>();
    _forgotPasswordKey = GlobalKey<FormState>();
    _signupFormKey = GlobalKey<FormState>();
    update();
  }

  ///----User Model
  UserModel userModel = UserModel(
    id: '',
    email: '',
    password: '',
    username: '',
    cpassword: '',
    isAdmin: false,
  );
  String userId = '';

  // المتغيرات الخاصة بعملية التحميل والظهور
  bool isLoading = false;
  bool isVisable = true;

  // تحديث القيم
  void setEmail(String newVal) {
    userModel.email = newVal;
    update();
  }

  void setUserId(String id) {
    userId = id;
    update();
  }

  void setName(String newVal) {
    userModel.username = newVal;
    update();
  }

  void setPassword(String newVal) {
    userModel.password = newVal;
    update();
  }

  void setCPassword(String newVal) {
    userModel.cpassword = newVal;
    update();
  }

  void setIsLoading(bool newVal) {
    isLoading = newVal;
    update();
  }

  void setIsVisable() {
    isVisable = !isVisable;
    update();
  }

  // مسح البيانات
  void clearData() {
    userModel = UserModel(
      id: '',
      email: '',
      password: '',
      username: '',
      cpassword: '',
      isAdmin: false,
    );
    update();
  }

  // دالة التسجيل
  Future<void> signUp(BuildContext context) async {
    FocusScope.of(context).unfocus();
    signupFormKey.currentState!.save();
    final bool isValid = signupFormKey.currentState!.validate();

    try {
      if (!userModel.email.isEmail) {
        myAleartDialog(text: 'Please enter a valid email');
      } else if (userModel.username.isEmpty) {
        myAleartDialog(text: 'Please enter your name');
      } else if (userModel.password.length <= 6 &&
          userModel.cpassword.length <= 6) {
        myAleartDialog(text: 'Password must be 6 characters at least');
      } else if (userModel.password != userModel.cpassword) {
        myAleartDialog(text: 'Passwords do not match');
      } else if (isValid) {
        setIsLoading(true);
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: userModel.email,
              password: userModel.password,
            )
            .then((UserCredential userCedential) {
              userModel.id = userCedential.user!.uid;

              setUserId(userCedential.user!.uid);

              DocumentReference ref = FirebaseFirestore.instance
                  .collection(AppStrings.users)
                  .doc(userCedential.user!.uid);

              ref.set(userModel.toMap()).then((val) {
                log('OK');

                // توجيه المستخدم إلى صفحة تسجيل الدخول بعد نجاح التسجيل
                clearData(); // مسح البيانات أولاً
                resetFormKeys(); // Reset form keys
                Get.off(
                  () => LoginScreen(),
                ); // استخدام Get.off للانتقال إلى صفحة الدخول
              });
              setIsLoading(false);
            });
      }
    } on FirebaseAuthException catch (e) {
      setIsLoading(false);
      log(e.toString());

      if (e.code == 'weak-password') {
        myAleartDialog(text: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        myAleartDialog(text: 'The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        myAleartDialog(text: 'The email address is badly formatted.');
      } else {
        log(e.toString());
      }
    }
  }

  // دالة تسجيل الدخول
  Future<void> logIn(BuildContext context) async {
    FocusScope.of(context).unfocus();
    loginFormKey.currentState!.save();
    final bool isValid = loginFormKey.currentState!.validate();

    try {
      if (!userModel.email.isEmail) {
        myAleartDialog(text: 'Please enter a valid email');
      } else if (userModel.password.length <= 6) {
        myAleartDialog(text: 'Passwords must be 6 characters at least');
      } else if (isValid) {
        setIsLoading(true);

        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: userModel.email,
              password: userModel.password,
            )
            .then((UserCredential userCedential) async {
              // تعيين userId عند تسجيل الدخول
              setUserId(userCedential.user!.uid);
              log('تم تعيين userId: ${userCedential.user!.uid}');

              // يمكنك أيضًا جلب بيانات المستخدم من Firestore إذا كنت بحاجة إليها
              DocumentSnapshot userDoc =
                  await FirebaseFirestore.instance
                      .collection(AppStrings.users)
                      .doc(userCedential.user!.uid)
                      .get();

              if (userDoc.exists) {
                // تحديث بيانات المستخدم إذا لزم الأمر
                Map<String, dynamic> userData =
                    userDoc.data() as Map<String, dynamic>;
                userModel = UserModel.fromJson(userData);
                userModel.id = userCedential.user!.uid;
                update();

                // التحقق إذا كان المستخدم مسؤول أم لا وتوجيهه إلى الصفحة المناسبة
                resetFormKeys(); // Reset form keys before navigation
                if (userModel.isAdmin) {
                  Get.offAll(() => const AdminView());
                } else {
                  Get.offAll(() => HomeScreen());
                }
              }

              setIsLoading(false);
            });
      }
    } on FirebaseAuthException catch (e) {
      myAleartDialog(text: e.toString());
      setIsLoading(false);
      log(e.toString());

      if (e.code == 'weak-password') {
        myAleartDialog(text: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        myAleartDialog(text: 'The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        myAleartDialog(text: 'The email address is badly formatted.');
      } else {
        log(e.toString());
      }
    }
  }

  // دالة إعادة تعيين كلمة المرور
  Future<bool> resetPassword(BuildContext context) async {
    FocusScope.of(context).unfocus();
    forgotPasswordKey.currentState!.save();
    final bool isValid = forgotPasswordKey.currentState!.validate();

    try {
      if (!userModel.email.isEmail) {
        myAleartDialog(text: 'Please enter a valid email');
        return false;
      } else if (isValid) {
        setIsLoading(true);

        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: userModel.email)
            .then((_) {
              setIsLoading(false);
              resetFormKeys(); // Reset form keys
              Get.back();
            });
        return true;
      }
    } on FirebaseAuthException catch (e) {
      setIsLoading(false);
      myAleartDialog(text: e.message ?? 'An error occurred.');
      log(e.toString());
      return false;
    }
    return false;
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      clearData(); // تمسح بيانات المستخدم
      resetFormKeys(); // Reset form keys
      Get.offAll(() => const LoginScreen()); // يرجع على صفحة تسجيل الدخول
    } catch (e) {
      log('Error signing out: $e');
    }
  }

  @override
  void onInit() {
    // Initialize new keys when controller is created
    resetFormKeys();
    super.onInit();
  }
}
