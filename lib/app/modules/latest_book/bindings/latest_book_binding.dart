import 'package:get/get.dart';

import '../controllers/latest_book_controller.dart';

class LatestBookBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LatestBookController>(
      () => LatestBookController(),
    );
  }
}
