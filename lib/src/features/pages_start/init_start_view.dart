import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/core/utils/app_strings.dart';
import 'package:e_reading/src/features/admin/view/admin_view.dart';
import 'package:e_reading/src/features/auth/controller/auth_crl.dart';
import 'package:e_reading/src/features/auth/model/user_model.dart';
import 'package:e_reading/src/features/auth/view/login/screen/login_screen.dart';
import 'package:e_reading/src/features/home/home_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class InitStartView extends StatelessWidget {
  const InitStartView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the AuthCrl instance
    final AuthCrl authCrl = Get.find<AuthCrl>();

    // Make sure form keys are reset when this view is built
    authCrl.resetFormKeys();

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapShot) {
        return GetBuilder<AuthCrl>(
          builder: (authCrl) {
            switch (snapShot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: AppColors.error,
                    size: 18,
                  ),
                );

              case ConnectionState.none:
                return Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: AppColors.error,
                    size: 18,
                  ),
                );

              case ConnectionState.active:

                ///---يعني المستخدم عامل تسجيل دخول
                if (snapShot.hasData) {
                  return StreamBuilder<dynamic>(
                    stream:
                        FirebaseFirestore.instance
                            .collection(AppStrings.users)
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .snapshots(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.hasData) {
                        if (userSnapshot.data.data() == null ||
                            userSnapshot.data == null) {
                          // Reset form keys before showing login screen
                          authCrl.resetFormKeys();
                          return const LoginScreen();
                        } else {
                          authCrl.userModel = UserModel.fromJson(
                            userSnapshot.data.data(),
                          );

                          if (authCrl.userModel.isAdmin) {
                            return const AdminView();
                          } else {
                            return HomeScreen();
                          }
                        }
                      } else {
                        return Center(
                          child: LoadingAnimationWidget.discreteCircle(
                            color: AppColors.error,
                            size: 18,
                          ),
                        );
                      }
                    },
                  );
                } else {
                  // Reset form keys before showing login screen
                  authCrl.resetFormKeys();
                  return const LoginScreen();
                }

              default:
            }
            return const SizedBox();
          },
        );
      },
    );
  }
}
