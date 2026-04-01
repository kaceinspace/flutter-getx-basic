import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rpl1getx/app/data/models/latests_book.dart';
import 'package:rpl1getx/app/services/dashboard_service.dart';

class DashboardController extends GetxController {
  final DashboardService _dashboardService = Get.put(DashboardService());
  final box = GetStorage();

  // Observable data
  RxList<LatestBook> latestBooks = <LatestBook>[].obs;
  RxList<dynamic> latestEbooks = <dynamic>[].obs;
  RxList<dynamic> latestVideos = <dynamic>[].obs;

  // Stats from API
  RxInt totalBooks = 0.obs;
  RxInt totalPdfs = 0.obs;
  RxInt totalVideos = 0.obs;

  // Loading states
  RxBool isLoading = false.obs;
  RxBool isLoadingBooks = false.obs;
  RxBool isLoadingSummary = false.obs;
  RxString errorMessage = ''.obs;

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

      await Future.wait([_loadHomeData(), _loadLatestBooks()]);
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

  Future<void> _loadHomeData() async {
    try {
      final response = await _dashboardService.fetchHome();
      if (response.statusCode == 200 && response.body != null) {
        final data = response.body['data'];
        if (data != null) {
          final stats = data['stats'];
          if (stats != null) {
            totalBooks.value = stats['total_books'] ?? 0;
            totalPdfs.value = stats['total_pdfs'] ?? 0;
            totalVideos.value = stats['total_videos'] ?? 0;
          }
        }
      }
    } catch (e) {
      print('Error loading home data: $e');
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
