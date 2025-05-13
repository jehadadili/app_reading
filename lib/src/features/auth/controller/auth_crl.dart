import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_reading/src/core/utils/app_strings.dart';
import 'package:e_reading/src/core/utils/my_aleart_dialog.dart';
import 'package:e_reading/src/features/auth/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthCrl extends GetxController {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> forgotpasswordKey = GlobalKey<FormState>();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  UserModel userModel = UserModel(
    id: '',
    email: '',
    password: '',
    username: '',
    cpassword: '',
    isAdmin: false,
  );
  String userId = '';

  bool isLoading = false;
  bool isVisable = true;

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

  void clearData() {
    userModel = UserModel(
      id: '',
      email: '',
      password: '',
      username: '',
      cpassword: '',
      isAdmin: false,
    );
    userId = '';
    isLoading = false;
    isVisable = true;
    update();
  }

  Future<void> signUp(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!signupFormKey.currentState!.validate()) {
      return;
    }
    signupFormKey.currentState!.save();

    try {
      if (!userModel.email.isEmail) {
        myAleartDialog(text: 'Please enter a valid email');
        return;
      } else if (userModel.username.isEmpty) {
        myAleartDialog(text: 'Please enter your name');
        return;
      } else if (userModel.password.length <= 6) {
        myAleartDialog(text: 'Password must be 6 characters at least');
        return;
      } else if (userModel.password != userModel.cpassword) {
        myAleartDialog(text: 'Passwords do not match');
        return;
      }

      setIsLoading(true);
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: userModel.email,
            password: userModel.password,
          );

      userModel.id = userCredential.user!.uid;
      await userCredential.user!.updateDisplayName(userModel.username);
      await userCredential.user!.reload(); // Refresh Firebase user data

      setUserId(
        userCredential.user!.uid,
      ); // Updates AuthCrl.userId (consider if needed)

      DocumentReference ref = FirebaseFirestore.instance
          .collection(AppStrings.users)
          .doc(userCredential.user!.uid);
      await ref.set(userModel.toMap());

      log('User created successfully. Firestore document written.');
    } on FirebaseAuthException catch (e) {
      log('SignUp FirebaseAuthException: ${e.toString()}');
      if (e.code == 'weak-password') {
        myAleartDialog(text: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        myAleartDialog(text: 'The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        myAleartDialog(text: 'The email address is badly formatted.');
      } else {
        myAleartDialog(text: e.message ?? 'An error occurred during sign up.');
      }
    } catch (e) {
      log('SignUp general error: ${e.toString()}');
      myAleartDialog(text: 'An unexpected error occurred during sign up.');
    } finally {
      setIsLoading(false);
      update(); // Ensure UI updates (e.g., loading indicator stops)
    }
  }

  Future<void> logIn(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!loginFormKey.currentState!.validate()) {
      return; // Validation failed
    }
    loginFormKey.currentState!.save();

    try {
      if (!userModel.email.isEmail) {
        myAleartDialog(text: 'Please enter a valid email');
        return;
      } else if (userModel.password.length <= 6) {
        myAleartDialog(text: 'Passwords must be 6 characters at least');
        return;
      }

      setIsLoading(true);
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: userModel.email,
            password: userModel.password,
          );

      setUserId(userCredential.user!.uid);
      log('User logged in. UID: ${userCredential.user!.uid}');

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection(AppStrings.users)
              .doc(userCredential.user!.uid)
              .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        _check_type_Map_String_dynamic(userData);
        userModel = UserModel.fromJson(userData);
        userModel.id = userCredential.user!.uid; // Ensure ID from auth is set
      } else {
        log(
          "User document not found in Firestore for UID: ${userCredential.user!.uid}. Logging out.",
        );
        await FirebaseAuth.instance.signOut();
        clearData();
        myAleartDialog(
          text:
              'User data not found. Please contact support or try signing up.',
        );
      }
    } on FirebaseAuthException catch (e) {
      log("Login FirebaseAuthException: ${e.toString()}, code: ${e.code}");
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        myAleartDialog(text: 'Invalid email or password.');
      } else if (e.code == 'invalid-email') {
        myAleartDialog(text: 'The email address is badly formatted.');
      } else {
        myAleartDialog(text: e.message ?? 'An error occurred during login.');
      }
    } catch (e) {
      log("Login general error: ${e.toString()}");
      myAleartDialog(text: 'An unexpected error occurred during login.');
    } finally {
      setIsLoading(false);
      update();
    }
  }

  Future<bool> resetPassword(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!forgotpasswordKey.currentState!.validate()) return false;
    forgotpasswordKey.currentState!.save();

    try {
      if (!userModel.email.isEmail) {
        myAleartDialog(text: 'Please enter a valid email');
        return false;
      }
      setIsLoading(true);
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: userModel.email,
      );
      myAleartDialog(text: 'Password reset email sent. Check your inbox.');
      Get.back(); // Close the dialog/screen where reset was initiated
      return true;
    } on FirebaseAuthException catch (e) {
      myAleartDialog(text: e.message ?? 'An error occurred.');
      log('ResetPassword error: ${e.toString()}');
      return false;
    } finally {
      setIsLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      setIsLoading(true);
      await FirebaseAuth.instance.signOut();
      clearData();
    } catch (e) {
      log('Error signing out: $e');
      myAleartDialog(text: 'Error signing out. Please try again.');
      setIsLoading(false);
      update();
    }
  }
}

Map<String, dynamic> _check_type_Map_String_dynamic(Map<String, dynamic> map) =>
    map;
