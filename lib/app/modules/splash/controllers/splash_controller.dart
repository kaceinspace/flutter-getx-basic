// filepath: lib/app/modules/splash/controllers/splash_controller.dart
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rpl1getx/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final box = GetStorage();
  RxBool isLoading = true.obs;
  RxDouble progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _startSplashTimer();
  }

  void _startSplashTimer() async {
    // Simulate loading progress
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 20));
      progress.value = i / 100;
    }

    // Wait a bit more for effect
    await Future.delayed(const Duration(milliseconds: 300));

    // Check authentication and navigate
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() {
    final token = box.read('token');

    if (token != null && token.toString().isNotEmpty) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
