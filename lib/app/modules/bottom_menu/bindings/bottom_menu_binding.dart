import 'package:get/get.dart';

import '../controllers/bottom_menu_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../cart/controllers/cart_controller.dart';

class BottomMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomMenuController>(() => BottomMenuController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<CartController>(() => CartController());
  }
}
