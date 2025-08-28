import 'package:get/get.dart';

class AuthService extends GetConnect {
  final authUrl = 'http://127.0.0.1:8000/api';

  @override
  void onInit() {
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Accept'] = 'application/json';
      return request;
    });
    super.onInit();
  }

  Future<Response> login(String email, String password) {
    return post(
      '$authUrl/login',
      {'email': email, 'password': password},
      headers: {'Accept': 'application/json'},
    );
  }

  Future<Response> register(String name, String email, String password) {
    return post(
      '$authUrl/register',
      {'name': name, 'email': email, 'password': password},
      headers: {'Accept': 'application/json'},
    );
  }

  Future<Response> logout(String token) {
    return post(
      '$authUrl/logout',
      {},
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }

  Future<Response> getProfile(String token) {
    return get(
      '$authUrl/user',
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }
}
