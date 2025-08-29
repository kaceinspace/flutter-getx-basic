import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
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

  Future<Response> createPost(
    Map<String, dynamic> data,
    File? image,
    Uint8List? imageBytes,
  ) async {
    final token = box.read("token");
    final form = FormData({
      'title': data['title'],
      'content': data['content'],
      'status': data['status'].toString(),
      if (kIsWeb && imageBytes != null)
        'foto': MultipartFile(
          imageBytes,
          filename: 'upload.png',
          contentType: 'image/png',
        ),
      if (!kIsWeb && image != null)
        'foto': MultipartFile(image, filename: image.path.split('/').last),
    });

    try {
      return await post(
        "$postUrl/posts",
        form,
        headers: {"Authorization": "Bearer $token"},
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: "Exception: $e");
    }
  }

  Future<Response> updatePost(
    int id,
    Map<String, dynamic> data,
    File? image,
    Uint8List? imageBytes,
  ) async {
    final token = box.read("token");
    final form = FormData({
      'title': data['title'],
      'content': data['content'],
      'status': data['status'].toString(),
      '_method': 'PUT', // Laravel method spoofing
      if (kIsWeb && imageBytes != null)
        'foto': MultipartFile(
          imageBytes,
          filename: 'upload.png',
          contentType: 'image/png',
        ),
      if (!kIsWeb && image != null)
        'foto': MultipartFile(image, filename: image.path.split('/').last),
    });

    try {
      return await post(
        "$postUrl/posts/$id",
        form,
        headers: {"Authorization": "Bearer $token"},
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: "Exception: $e");
    }
  }

  Future<Response> deletePost(int id) async {
    try {
      final token = box.read("token");
      return await delete(
        "$postUrl/posts/$id",
        headers: {"Authorization": "Bearer $token"},
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: "Exception: $e");
    }
  }
}
