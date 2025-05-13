import 'package:e_reading/src/core/config/bindings.dart';
import 'package:e_reading/src/features/spalsh_screen/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
              initialBinding: MyBindings(),

        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      
    );
  }
}
