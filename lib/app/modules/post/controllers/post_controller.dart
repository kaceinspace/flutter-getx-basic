import 'package:get/get.dart';
import 'package:rpl1getx/app/data/models/post.dart';
import 'package:rpl1getx/app/services/post_service.dart';

class PostController extends GetxController {
  final PostService _postService = Get.put<PostService>(PostService());

  RxList posts = <Post>[].obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPost();
  }

  void fetchPost() async {
    try {
      isLoading(true);
      errorMessage('');
      final response = await _postService.fetchPosts();
      if (response.statusCode == 200) {
        var data = response.body!
            .map((postJson) => Post.fromJson(postJson))
            .toList();
        posts.assignAll(data);
      } else {
        errorMessage('Error: ${response.statusText}');
      }
    } catch (e) {
      errorMessage('Exception: $e');
    } finally {
      isLoading(false);
    }
  }
}
