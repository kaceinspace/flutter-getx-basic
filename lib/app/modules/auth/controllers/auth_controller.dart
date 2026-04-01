import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rpl1getx/app/routes/app_pages.dart';
import 'package:rpl1getx/app/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService api = Get.put(AuthService());
  final box = GetStorage();

  RxBool isLoading = false.obs;
  RxBool isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading(true);
      final response = await api.login(email, password);

      if (response.statusCode == 200) {
        final body = response.body;
        final token = body['data']?['token'] ?? body['token'];
        if (token == null || token.toString().isEmpty) {
          Get.snackbar(
            'Error',
            'Token tidak ditemukan dalam response',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
          return;
        }
        box.write('token', token);

        // Fix navigation - pake offAllNamed dengan proper route
        Get.offAllNamed(Routes.HOME);

        Get.snackbar(
          'Berhasil',
          'Login berhasil! Selamat datang di perpustakaan digital',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        final msg = response.body is Map
            ? (response.body['message'] ?? 'Email atau password salah')
            : 'Email atau password salah';
        Get.snackbar(
          'Gagal Login',
          msg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      isLoading(true);
      final token = box.read('token');

      if (token != null) {
        await api.logout(token);
        box.remove('token');
      }

      // Clear semua controller yang mungkin cached
      Get.reset();

      // Navigate ke login
      Get.offAllNamed(Routes.LOGIN);

      Get.snackbar(
        'Logout',
        'Anda telah keluar dari sistem',
        backgroundColor: const Color(0xFF6B7280),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (e) {
      // Tetap logout meski API gagal
      box.remove('token');
      Get.reset();
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading(false);
    }
  }
}
