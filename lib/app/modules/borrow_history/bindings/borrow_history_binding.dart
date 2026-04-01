import 'package:get/get.dart';
import '../controllers/borrow_history_controller.dart';

class BorrowHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BorrowHistoryController>(() => BorrowHistoryController());
  }
}
