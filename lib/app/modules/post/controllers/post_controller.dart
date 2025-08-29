import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rpl1getx/app/data/models/post.dart';
import 'package:rpl1getx/app/services/post_service.dart';

class PostController extends GetxController {
  final PostService _postService = Get.put(PostService());

  RxList<DataPost> posts = <DataPost>[].obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  Rx<File?> selectedImage = Rx<File?>(null);
  Rx<Uint8List?> selectedImageBytes = Rx<Uint8List?>(null);

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        selectedImageBytes.value = await picked.readAsBytes();
        selectedImage.value = null;
      } else {
        selectedImage.value = File(picked.path);
        selectedImageBytes.value = null;
      }
    }
  }

  void clearSelectedImage() {
    selectedImage.value = null;
    selectedImageBytes.value = null;
  }

  // 🔹 Fetch Posts
  Future<void> fetchPosts() async {
    try {
      isLoading(true);
      errorMessage('');
      final response = await _postService.fetchPosts();

      if (response.statusCode == 200) {
        final postModel = Post.fromJson(response.body);
        posts.assignAll(postModel.data ?? []);
      } else {
        errorMessage('Error: ${response.statusText}');
      }
    } catch (e) {
      errorMessage('Exception: $e');
    } finally {
      isLoading(false);
    }
  }

  // 🔹 Create Post
  Future<bool> createPost(String title, String content) async {
    try {
      if (title.isEmpty || content.isEmpty) {
        Get.snackbar("Error", "Title and content cannot be empty!");
        return false;
      }

      isLoading(true);
      final data = {"title": title, "content": content, "status": 1};
      final response = await _postService.createPost(
        data,
        selectedImage.value,
        selectedImageBytes.value,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar("Success", "Post created successfully!");
        clearSelectedImage();

        // Refresh data dan redirect
        await fetchPosts();
        Get.offAllNamed('/post'); // Redirect ke post list
        return true;
      } else {
        Get.snackbar("Error", "Failed: ${response.statusText}");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
      return false;
    } finally {
      isLoading(false);
    }
  }

  // 🔹 Update Post
  Future<bool> updatePost(int id, String title, String content) async {
    try {
      if (title.isEmpty || content.isEmpty) {
        Get.snackbar("Error", "Title and content cannot be empty!");
        return false;
      }

      isLoading(true);
      final data = {"title": title, "content": content, "status": 1};
      final response = await _postService.updatePost(
        id,
        data,
        selectedImage.value,
        selectedImageBytes.value,
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Post updated successfully!");
        clearSelectedImage();

        // Refresh data dan redirect
        await fetchPosts();
        Get.offAllNamed('/post'); // Redirect ke post list
        return true;
      } else {
        Get.snackbar("Error", "Failed: ${response.statusText}");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
      return false;
    } finally {
      isLoading(false);
    }
  }

  // 🔹 Delete Post
  Future<bool> deletePost(int id) async {
    try {
      isLoading(true);
      final response = await _postService.deletePost(id);
      if (response.statusCode == 200) {
        Get.snackbar("Success", "Post deleted successfully!");

        // Refresh data dan redirect
        await fetchPosts();
        Get.offAllNamed('/post'); // Redirect ke post list
        return true;
      } else {
        Get.snackbar("Error", "Failed: ${response.statusText}");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
      return false;
    } finally {
      isLoading(false);
    }
  }
}
