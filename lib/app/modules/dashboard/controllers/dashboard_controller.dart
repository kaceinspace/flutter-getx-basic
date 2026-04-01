import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rpl1getx/app/data/models/book_model.dart';
import 'package:rpl1getx/app/routes/app_pages.dart';
import 'package:rpl1getx/app/services/auth_service.dart';
import 'package:rpl1getx/app/services/dashboard_service.dart';

class DashboardController extends GetxController {
  final _dashboardService = Get.put(DashboardService());
  final _authService = Get.put(AuthService());
  final box = GetStorage();

  final isLoading = true.obs;
  final userName = ''.obs;
  final userGrade = ''.obs;
  final borrowedCount = 0.obs;
  final returningSoon = 0.obs;

  final books = <BookModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final stats = Rxn<HomeStatsModel>();

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    try {
      isLoading(true);
      await Future.wait([
        _fetchProfile(),
        _fetchHome(),
        _fetchCategories(),
        _fetchBorrowHistory(),
      ]);
    } finally {
      isLoading(false);
    }
  }

  Future<void> _fetchProfile() async {
    try {
      final response = await _authService.getProfile();
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body;
        if (body['status'] == true && body['data'] != null) {
          final data = body['data'];
          userName.value = data['name'] ?? '';
          final kelas = data['kelas'] ?? '';
          final jurusan = data['jurusan'] ?? '';
          userGrade.value = '$kelas $jurusan'.trim();
        }
      } else if (response.statusCode == 401) {
        box.remove('token');
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (_) {}
  }

  Future<void> _fetchHome() async {
    try {
      final response = await _dashboardService.getHome();
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body;
        if (body['status'] == true && body['data'] != null) {
          final data = body['data'];

          // Books
          if (data['books'] != null) {
            books.value = (data['books'] as List)
                .map((b) => BookModel.fromJson(b))
                .toList();
          }

          // Stats
          if (data['stats'] != null) {
            stats.value = HomeStatsModel.fromJson(data['stats']);
          }
        }
      }
    } catch (_) {}
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await _dashboardService.getCategories();
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body;
        if (body['status'] == true && body['data'] != null) {
          categories.value = (body['data'] as List)
              .map((c) => CategoryModel.fromJson(c))
              .toList();
        }
      }
    } catch (_) {}
  }

  Future<void> _fetchBorrowHistory() async {
    try {
      final response = await _dashboardService.getBorrowHistory();
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body;
        if (body['status'] == true && body['data'] != null) {
          final data = body['data'];
          final borrowings = data['borrowings'];
          if (borrowings != null && borrowings['data'] != null) {
            final list = borrowings['data'] as List;
            // Count active borrows (status = borrowed/approved)
            int borrowed = 0;
            int soonest = 999;
            for (var b in list) {
              final status = b['status']?.toString().toLowerCase() ?? '';
              if (status == 'borrowed' || status == 'approved') {
                borrowed++;
                // Calculate days until due
                if (b['return_date'] != null) {
                  final returnDate = DateTime.tryParse(
                    b['return_date'].toString(),
                  );
                  if (returnDate != null) {
                    final daysLeft = returnDate
                        .difference(DateTime.now())
                        .inDays;
                    if (daysLeft < soonest) soonest = daysLeft;
                  }
                }
              }
            }
            borrowedCount.value = borrowed;
            returningSoon.value = soonest == 999
                ? 0
                : (soonest < 0 ? 0 : soonest);
          }
        }
      }
    } catch (_) {}
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }
}
