import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rpl1getx/app/routes/app_pages.dart';
import 'package:rpl1getx/app/services/auth_service.dart';

class LoginController extends GetxController {
  final box = GetStorage();
  final authService = Get.put(AuthService());

  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;
  final rememberMe = false.obs;

  void togglePassword() => isPasswordHidden.toggle();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading(true);

      final response = await authService.login(
        emailC.text.trim(),
        passwordC.text,
      );

      if (response.statusCode == 200 && response.body != null) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;

        final token = body['data']?['token'] ?? body['token'];

        if (token == null || token.toString().isEmpty) {
          _showError('Token tidak ditemukan');
          return;
        }

        box.write('token', token);
        isLoading(false);

        Get.offAllNamed(Routes.BOTTOM_MENU);
      } else {
        final body = response.body;
        final msg = body is Map
            ? (body['message'] ?? 'Email atau password salah')
            : 'Email atau password salah';
        _showError(msg);
      }
    } catch (e) {
      _showError('Gagal terhubung ke server');
    } finally {
      isLoading(false);
    }
  }

  void _showError(String message) {
    Get.snackbar(
      'Login Gagal',
      message,
      backgroundColor: Colors.red.shade600,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.error_outline, color: Colors.white),
    );
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
