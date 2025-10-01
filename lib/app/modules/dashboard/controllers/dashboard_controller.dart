import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rpl1getx/app/data/models/dashboard.dart';
import 'package:rpl1getx/app/services/dashboard_service.dart';

class DashboardController extends GetxController {
  final DashboardService _dashboardService = Get.put(DashboardService());
  final box = GetStorage();

  // Observable data
  Rx<Dashboard?> dashboardData = Rx<Dashboard?>(null);
  RxList<LatestBook> latestBooks = <LatestBook>[].obs;
  Rx<Summary?> summary = Rx<Summary?>(null);
  RxList<dynamic> latestEbooks = <dynamic>[].obs;
  RxList<dynamic> latestVideos = <dynamic>[].obs;

  // Loading states
  RxBool isLoading = false.obs;
  RxBool isLoadingBooks = false.obs;
  RxBool isLoadingSummary = false.obs;
  RxString errorMessage = ''.obs;

  // Computed properties untuk stats
  int get totalBooks => summary.value?.totalBooks ?? 0;
  int get totalEbooks => summary.value?.totalEbooks ?? 0;
  int get totalVideos => summary.value?.totalVideos ?? 0;
  int get borrowedBooks => 3; // Placeholder

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading(true);
      errorMessage('');

      final token = box.read('token');
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      // Load all data parallel
      await Future.wait([_loadLatestBooks()]);
    } catch (e) {
      errorMessage('Gagal memuat data dashboard: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Gagal memuat data dashboard',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> _loadLatestBooks() async {
    try {
      isLoadingBooks(true);
      final response = await _dashboardService.fetchLatestBooks();

      if (response.statusCode == 200 && response.body != null) {
        latestBooks.assignAll(response.body!);
      } else {
        throw Exception('Failed to load books: ${response.statusText}');
      }
    } catch (e) {
      print('Error loading books: $e');
      latestBooks.assignAll(latestBooks);
    } finally {
      isLoadingBooks(false);
    }
  }

  Future<void> refreshDashboard() async {
    await loadDashboardData();

    if (errorMessage.value.isEmpty) {
      Get.snackbar(
        'Berhasil',
        'Dashboard berhasil diperbarui',
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    }
  }
}
