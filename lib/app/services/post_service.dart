import 'dart:io';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class PostService extends GetConnect {
  final String postUrl = "http://127.0.0.1:8000/api";
  final box = GetStorage();

  Future<Response> fetchPosts() async {
    try {
      final token = box.read("token");
      return await get(
        "$postUrl/posts",
        headers: {"Authorization": "Bearer $token"},
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: "Exception: $e");
    }
  }

  Future<Response> createPost(Map<String, dynamic> data, File? image) async {
    final form = FormData({
      'title': data['title'],
      'content': data['content'],
      'status': data['status'].toString(),
      if (image != null)
        'foto': MultipartFile(image, filename: image.path.split('/').last),
    });

    try {
      return await post("$postUrl/posts", form);
    } catch (e) {
      return Response(statusCode: 500, statusText: "Exception: $e");
    }
  }

  Future<Response> updatePost(
    int id,
    Map<String, dynamic> data,
    File? image,
  ) async {
    final form = FormData({
      'title': data['title'],
      'content': data['content'],
      'status': data['status'].toString(),
      if (image != null)
        'foto': MultipartFile(image, filename: image.path.split('/').last),
    });

    try {
      return await put("$postUrl/posts/$id", form);
    } catch (e) {
      return Response(statusCode: 500, statusText: "Exception: $e");
    }
  }

  Future<Response> deletePost(int id) async {
    try {
      return await delete("$postUrl/posts/$id");
    } catch (e) {
      return Response(statusCode: 500, statusText: "Exception: $e");
    }
  }
}
