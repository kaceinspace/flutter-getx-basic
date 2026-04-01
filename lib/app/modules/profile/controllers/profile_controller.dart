import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rpl1getx/app/routes/app_pages.dart';
import 'package:rpl1getx/app/services/auth_service.dart';

class ProfileController extends GetxController {
  final _authService = Get.put(AuthService());
  final box = GetStorage();

  final isLoading = true.obs;
  final userData = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading(true);
      final response = await _authService.getProfile();

      if (response.statusCode == 200 && response.body != null) {
        final body = response.body;
        if (body['status'] == true && body['data'] != null) {
          userData.value = Map<String, dynamic>.from(body['data']);
        }
      } else if (response.statusCode == 401) {
        box.remove('token');
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat profil',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.white)),
        barrierDismissible: false,
      );

      await _authService.logout();
      box.remove('token');

      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      box.remove('token');
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  // Helpers
  String get name => userData.value?['name'] ?? '-';
  String get email => userData.value?['email'] ?? '-';
  String get nis => userData.value?['nis'] ?? '-';
  String get phone => userData.value?['phone_number'] ?? '-';
  String get address => userData.value?['address'] ?? '-';
  String get jurusan => userData.value?['jurusan'] ?? '-';
  String get role => userData.value?['role'] ?? '-';
  String get status => userData.value?['status'] ?? '-';
  String get jenisKelamin => userData.value?['jenis_kelamin'] ?? '-';
  String get gradeName => userData.value?['grade']?['name'] ?? '-';
  String get schoolYear => userData.value?['grade']?['school_year'] ?? '-';

  String get avatarUrl =>
      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=1E3A8A&color=fff&size=128';
}
