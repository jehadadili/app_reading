import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/features/auth/controller/auth_crl.dart';
import 'package:e_reading/src/features/favorites/favorites_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: GetBuilder<AuthCrl>(
        builder: (controller) {
          final userModel = controller.userModel;
          final isLoggedIn = userModel.username.isNotEmpty;

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: AppColors.primary),
                accountName: Text(
                  isLoggedIn ? userModel.username : 'Guest User',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
                accountEmail: Text(
                  isLoggedIn ? userModel.email : 'Please login',
                  style: const TextStyle(color: Colors.white70),
                ),
                currentAccountPicture: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.cover,
                      color: AppColors.white,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.favorite),
                title: const Text('My Favorites'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Sign Out'),
                onTap: () {
                  Get.find<AuthCrl>().signOut();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
