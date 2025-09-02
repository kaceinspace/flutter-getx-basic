import 'package:get/get.dart';
import '../utils/constants.dart';
import '../utils/api_helper.dart';

class AuthService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers.addAll(ApiConstants.defaultHeaders);
      return request;
    });
    super.onInit();
  }

  Future<Response> login(String email, String password) {
    return post(
      ApiConstants.login,
      {'email': email, 'password': password},
    );
  }

  Future<Response> register(String name, String email, String password) {
    return post(
      ApiConstants.register,
      {'name': name, 'email': email, 'password': password},
    );
  }

  Future<Response> logout(String token) {
    return post(
      ApiConstants.logout,
      {},
      headers: ApiHelper.getAuthHeaders(),
    );
  }

  Future<Response> getProfile(String token) {
    return get(
      ApiConstants.user,
      headers: ApiHelper.getAuthHeaders(),
    );
  }
}
