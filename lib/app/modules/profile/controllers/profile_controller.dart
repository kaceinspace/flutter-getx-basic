import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rpl1getx/app/services/auth_service.dart';
import 'package:rpl1getx/app/utils/api.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.put(AuthService());
  final box = GetStorage();

  RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading(true);
      errorMessage('');

      final token = box.read('token');
      if (token == null) {
        errorMessage('Token not found');
        return;
      }

      final response = await _authService.getProfile(token);

      if (response.statusCode == BaseUrl.success) {
        // Handle new API response structure
        if (response.body != null && response.body['status'] == true) {
          userProfile.value = response.body['data'] ?? {};
        } else {
          errorMessage(response.body['message'] ?? 'Failed to load profile');
        }
      } else {
        errorMessage('Error: ${response.statusText}');
      }
    } catch (e) {
      errorMessage('Exception: $e');
      print('Profile fetch error: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshProfile() async {
    await fetchProfile();

    if (errorMessage.value.isEmpty) {
      Get.snackbar(
        'Berhasil',
        'Profil berhasil diperbarui',
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } else {
      Get.snackbar(
        'Error',
        'Gagal memperbarui profil',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'Tidak Diketahui';
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return 'Format Tanggal Invalid';
    }
  }

  String getRoleDisplayName(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
        return 'Administrator';
      case 'teacher':
        return 'Guru';
      case 'member':
      default:
        return 'Siswa';
    }
  }

  Color getRoleColor(String? role) {
    switch (role?.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'teacher':
        return Colors.orange;
      case 'member':
      default:
        return const Color(0xFF1E3A8A);
    }
  }

  // Helper methods for new API structure
  String getGradeName() {
    final grade = userProfile.value['grade'];
    if (grade != null && grade is Map<String, dynamic>) {
      return grade['name']?.toString() ?? 'Tidak Ada Kelas';
    }
    return 'Tidak Ada Kelas';
  }

  String getGradeSchoolYear() {
    final grade = userProfile.value['grade'];
    if (grade != null && grade is Map<String, dynamic>) {
      return grade['school_year']?.toString() ?? 'Tahun Ajaran Tidak Diketahui';
    }
    return 'Tahun Ajaran Tidak Diketahui';
  }

  String getStatusDisplayName(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return 'Aktif';
      case 'inactive':
        return 'Nonaktif';
      case 'suspended':
        return 'Diskors';
      default:
        return 'Tidak Diketahui';
    }
  }

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.grey;
      case 'suspended':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
