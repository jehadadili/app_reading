import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_reading/src/core/style/color.dart';
import 'package:e_reading/src/features/auth/controller/auth_crl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDesign extends StatefulWidget {
  const CustomDesign({super.key});

  @override
  State<CustomDesign> createState() => _CustomDesignState();
}

class _CustomDesignState extends State<CustomDesign> {
  String? username;

  @override
  void initState() {
    super.initState();
    getUsernameFromFirestore();
  }

  Future<void> getUsernameFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final doc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (!mounted) return; // تأكد أن الودجت مازال حي قبل setState

        setState(() {
          username = doc.data()?['username'] ?? 'Admin';
        });
      } catch (e) {
        if (mounted) {
          setState(() {
            username = 'Admin';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hi ${username ?? ''}!",
                style: TextStyle(
                  color: AppColors.background,
                  fontSize: screenWidth > 600 ? 30 : 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.find<AuthCrl>().signOut();
                },
                icon: const Icon(Icons.logout, color: AppColors.background),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            "Welcome back to your panel.",
            style: TextStyle(
              color: AppColors.background,
              fontSize: screenWidth > 600 ? 25 : 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: screenHeight * 0.05),
          const Center(
            child: Text(
              "List Item",
              style: TextStyle(
                fontSize: 20,
                color: AppColors.background,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
