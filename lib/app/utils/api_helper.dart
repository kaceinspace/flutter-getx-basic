import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'constants.dart';

class ApiHelper {
  static final box = GetStorage();
  
  static Map<String, String> getAuthHeaders() {
    final token = box.read("token");
    return {
      ...ApiConstants.defaultHeaders,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
    return '${ApiConstants.storageUrl}/$imagePath';
  }
  
  static void handleError(Response response) {
    switch (response.statusCode) {
      case ApiConstants.unauthorized:
        Get.snackbar(
          'Error',
          'Session expired. Please login again.',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        // Redirect to login
        Get.offAllNamed('/login');
        break;
      case ApiConstants.serverError:
        Get.snackbar(
          'Server Error',
          'Something went wrong. Please try again later.',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
        break;
      default:
        Get.snackbar(
          'Error',
          response.statusText ?? 'Unknown error occurred',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
    }
  }
}