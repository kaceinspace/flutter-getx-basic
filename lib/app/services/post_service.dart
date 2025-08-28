import 'package:get/get.dart';

class PostService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://jsonplaceholder.typicode.com';
    super.onInit();
  }

  Future<Response<List<dynamic>>> fetchPosts() {
    return get('/posts');
  }
}
