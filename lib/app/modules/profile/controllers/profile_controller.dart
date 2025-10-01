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
        userProfile.value = response.body ?? {};
      } else {
        errorMessage('Error: ${response.statusText}');
      }
    } catch (e) {
      errorMessage('Exception: $e');
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
      );
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid Date';
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
}
