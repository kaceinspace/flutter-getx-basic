import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rpl1getx/app/utils/api.dart';
import 'package:rpl1getx/app/utils/api_helper.dart';

class ProfileEditController extends GetxController {
  final _connect = GetConnect();
  final box = GetStorage();

  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isPasswordLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _connect.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      phoneController.text = args['phone_number'] ?? '';
      addressController.text = args['address'] ?? '';
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading(true);
      final response = await _connect.put(BaseUrl.updateProfile, {
        'phone_number': phoneController.text,
        'address': addressController.text,
      }, headers: ApiHelper.getAuthHeaders());
      if (response.statusCode == 200) {
        Get.back(result: true);
        Get.snackbar(
          'Berhasil',
          'Profil berhasil diperbarui',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
        );
      } else {
        final errors = response.body?['errors'];
        String msg = response.body?['message'] ?? 'Gagal memperbarui profil';
        if (errors != null && errors is Map) {
          msg = errors.values.first is List ? errors.values.first[0] : msg;
        }
        Get.snackbar(
          'Gagal',
          msg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> updatePassword() async {
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Gagal',
        'Password baru tidak sama',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (newPasswordController.text.length < 8) {
      Get.snackbar(
        'Gagal',
        'Password minimal 8 karakter',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    try {
      isPasswordLoading(true);
      final response = await _connect.put(BaseUrl.updatePassword, {
        'current_password': currentPasswordController.text,
        'password': newPasswordController.text,
        'password_confirmation': confirmPasswordController.text,
      }, headers: ApiHelper.getAuthHeaders());
      if (response.statusCode == 200) {
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        Get.snackbar(
          'Berhasil',
          'Password berhasil diperbarui',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
        );
      } else {
        final msg = response.body?['message'] ?? 'Gagal memperbarui password';
        Get.snackbar(
          'Gagal',
          msg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isPasswordLoading(false);
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    addressController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
