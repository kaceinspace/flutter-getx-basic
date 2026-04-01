import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/data/models/borrow_model.dart';
import 'package:rpl1getx/app/services/borrow_service.dart';

class BorrowHistoryController extends GetxController {
  final BorrowService _borrowService = Get.put(BorrowService());

  RxList<BorrowData> borrows = <BorrowData>[].obs;
  RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory({int page = 1}) async {
    try {
      isLoading(true);
      final response = await _borrowService.getBorrowHistory(page: page);
      if (response.statusCode == 200 && response.body != null) {
        final parsed = BorrowHistoryResponse.fromJson(response.body);
        if (parsed.data != null) {
          if (page == 1) {
            borrows.assignAll(parsed.data!.borrowings.data);
          } else {
            borrows.addAll(parsed.data!.borrowings.data);
          }
          currentPage.value = parsed.data!.borrowings.currentPage;
          lastPage.value = parsed.data!.borrowings.lastPage;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat riwayat peminjaman',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  @override
  Future<void> refresh() async {
    currentPage.value = 1;
    await loadHistory(page: 1);
  }

  Future<void> loadMore() async {
    if (currentPage.value < lastPage.value) {
      await loadHistory(page: currentPage.value + 1);
    }
  }

  bool get hasMore => currentPage.value < lastPage.value;

  Color getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'borrowed':
        return const Color(0xFF1E3A8A);
      case 'returned':
        return const Color(0xFF10B981);
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
