import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rpl1getx/app/routes/app_pages.dart';
import 'package:rpl1getx/app/services/auth_service.dart';

class ProfileController extends GetxController {
  final _authService = Get.put(AuthService());
  final box = GetStorage();

  final isLoading = true.obs;
  final errorMessage = ''.obs;
  final userData = Rxn<Map<String, dynamic>>();

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
      debugPrint('[Profile] token: $token');

      final response = await _authService.getProfile();
      debugPrint('[Profile] status: ${response.statusCode}');
      debugPrint('[Profile] body type: ${response.body.runtimeType}');
      debugPrint('[Profile] body: ${response.body}');

      if (response.statusCode == 200) {
        final raw = response.body;
        if (raw == null) {
          errorMessage('Response kosong dari server');
          return;
        }
        final body = raw is String ? jsonDecode(raw) : raw;
        final data = body['data'];
        if (data != null) {
          userData.value = Map<String, dynamic>.from(data);
          debugPrint('[Profile] loaded: ${userData.value}');
        } else {
          errorMessage('Data tidak ditemukan dalam response');
        }
      } else if (response.statusCode == 401) {
        box.remove('token');
        Get.offAllNamed(Routes.LOGIN);
      } else {
        errorMessage('Server error: ${response.statusCode}');
      }
    } catch (e, st) {
      debugPrint('[Profile] EXCEPTION: $e');
      debugPrint('[Profile] stack: $st');
      errorMessage('Error: $e');
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

  // Helpers — null or empty string both show '-'
  String _v(dynamic val) {
    if (val == null) return '-';
    final s = val.toString().trim();
    return s.isEmpty ? '-' : s;
  }

  String get name => _v(userData.value?['name']);
  String get email => _v(userData.value?['email']);
  String get nis => _v(userData.value?['nis']);
  String get phone => _v(userData.value?['phone_number']);
  String get address => _v(userData.value?['address']);
  String get jurusan => _v(userData.value?['jurusan']);
  String get role => _v(userData.value?['role']);
  String get status => _v(userData.value?['status']);
  String get jenisKelamin => _v(userData.value?['jenis_kelamin']);
  String get gradeName => _v(userData.value?['grade']?['name']);
  String get schoolYear => _v((userData.value?['grade'])?['school_year']);

  String get avatarUrl =>
      'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=1E3A8A&color=fff&size=128';
}
