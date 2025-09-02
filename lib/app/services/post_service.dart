import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';
import '../utils/api_helper.dart';

class PostService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;
    httpClient.defaultContentType = 'application/json';
    super.onInit();
  }

  Future<Response> fetchPosts() async {
    try {
      return await get(ApiConstants.posts, headers: ApiHelper.getAuthHeaders());
    } catch (e) {
      return Response(
        statusCode: ApiConstants.serverError,
        statusText: "Exception: $e",
      );
    }
  }

  Future<Response> createPost(
    Map<String, dynamic> data,
    File? image,
    Uint8List? imageBytes,
  ) async {
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
        ApiConstants.posts,
        form,
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(
        statusCode: ApiConstants.serverError,
        statusText: "Exception: $e",
      );
    }
  }

  Future<Response> updatePost(
    int id,
    Map<String, dynamic> data,
    File? image,
    Uint8List? imageBytes,
  ) async {
    final form = FormData({
      'title': data['title'],
      'content': data['content'],
      'status': data['status'].toString(),
      '_method': 'PUT',
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
        '${ApiConstants.posts}/$id',
        form,
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(
        statusCode: ApiConstants.serverError,
        statusText: "Exception: $e",
      );
    }
  }

  Future<Response> deletePost(int id) async {
    try {
      return await delete(
        '${ApiConstants.posts}/$id',
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(
        statusCode: ApiConstants.serverError,
        statusText: "Exception: $e",
      );
    }
  }
}
