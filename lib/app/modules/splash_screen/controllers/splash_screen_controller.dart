import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rpl1getx/app/routes/app_pages.dart';

class SplashScreenController extends GetxController {
  final box = GetStorage();
  final progress = 0.0.obs;

  @override
  void onReady() {
    super.onReady();
    _runSplash();
  }

  Future<void> _runSplash() async {
    try {
      // Animate progress
      for (int i = 0; i <= 100; i++) {
        await Future.delayed(const Duration(milliseconds: 25));
        progress.value = i / 100;
      }

      await Future.delayed(const Duration(milliseconds: 300));

      // Check token
      final token = box.read('token');
      if (token != null && token.toString().isNotEmpty) {
        Get.offAllNamed(Routes.BOTTOM_MENU);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (_) {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
