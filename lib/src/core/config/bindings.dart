import 'package:e_reading/src/features/admin/controller/admin_create_crl.dart';
import 'package:e_reading/src/features/admin/controller/admin_crl.dart';
import 'package:e_reading/src/features/auth/controller/auth_crl.dart';
import 'package:e_reading/src/features/book_details/controller/rating_controller.dart';
import 'package:e_reading/src/features/home/controller/book_controller.dart';
import 'package:get/get.dart';

class MyBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthCrl());
    Get.put(BookController());
    Get.put(AdminCreateCrl());
    Get.put(AdminCrl());
    Get.put(RatingController());
  }
}
