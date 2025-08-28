import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rpl1getx/app/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService api = AuthService();
  final box = GetStorage();

  RxBool isLoading = false.obs;

  Future<void> login(String email, String password) async {
    try {
      isLoading(true);
      final response = await api.login(email, password);
      if (response.statusCode == 200) {
        final token = response.body['access_token'];
        box.write('token', token);
        Get.offAllNamed('/home');
      } else {
        Get.snackbar('Error', response.statusText ?? 'Login failed');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      isLoading(true);
      final response = await api.register(name, email, password);
      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Registration successful. Please log in.');
        Get.offAllNamed('/auth/login');
      } else {
        Get.snackbar('Error', response.statusText ?? 'Registration failed');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      isLoading(true);
      final token = box.read('token');
      if (token != null) {
        final response = await api.logout(token);
        if (response.statusCode == 200) {
          box.remove('token');
          Get.offAllNamed('/auth/login');
        } else {
          Get.snackbar('Error', response.statusText ?? 'Logout failed');
        }
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
