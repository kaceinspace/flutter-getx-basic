import 'dart:io';
import 'package:flutter/material.dart';
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

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage.value = File(picked.path);
    }
  }

  // 🔹 Fetch
  void fetchPosts() async {
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

  // 🔹 Create
  Future<bool> createPost(String title, String content) async {
    try {
      final data = {"title": title, "content": content, "status": 1};
      final response = await _postService.createPost(data, selectedImage.value);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final newPost = DataPost.fromJson(response.body['data']);
        posts.insert(0, newPost);
        Get.snackbar("Success", "Post created successfully!");
        selectedImage.value = null;
        return true;
      } else {
        Get.snackbar("Error", "Failed: ${response.statusText}");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
      return false;
    }
  }

  // 🔹 Update
  Future<bool> updatePost(int id, String title, String content) async {
    try {
      final data = {"title": title, "content": content, "status": 1};
      final response = await _postService.updatePost(
        id,
        data,
        selectedImage.value,
      );

      if (response.statusCode == 200) {
        final updatedPost = DataPost.fromJson(response.body['data']);
        final index = posts.indexWhere((p) => p.id == id);
        if (index != -1) {
          posts[index] = updatedPost;
        }
        Get.snackbar("Success", "Post updated successfully!");
        selectedImage.value = null;
        return true;
      } else {
        Get.snackbar("Error", "Failed: ${response.statusText}");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
      return false;
    }
  }

  // 🔹 Delete
  Future<bool> deletePost(int id) async {
    try {
      final response = await _postService.deletePost(id);
      if (response.statusCode == 200) {
        posts.removeWhere((p) => p.id == id);
        Get.snackbar("Success", "Post deleted successfully!");
        return true;
      } else {
        Get.snackbar("Error", "Failed: ${response.statusText}");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Exception: $e");
      return false;
    }
  }
}
