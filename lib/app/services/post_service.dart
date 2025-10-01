import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../utils/api.dart';
import '../utils/api_helper.dart';

class PostService extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers.addAll(BaseUrl.defaultHeaders);
      return request;
    });
    super.onInit();
  }

  Future<Response> fetchPosts() async {
    try {
      return await get(BaseUrl.posts, headers: ApiHelper.getAuthHeaders());
    } catch (e) {
      return Response(
        statusCode: BaseUrl.serverError,
        statusText: 'Network Error: ${e.toString()}',
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
        'foto': MultipartFile(imageBytes, filename: 'image.jpg'),
      if (!kIsWeb && image != null)
        'foto': MultipartFile(image, filename: image.path.split('/').last),
    });

    try {
      return await post(
        BaseUrl.createPost,
        form,
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(
        statusCode: BaseUrl.serverError,
        statusText: 'Network Error: ${e.toString()}',
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
        'foto': MultipartFile(imageBytes, filename: 'image.jpg'),
      if (!kIsWeb && image != null)
        'foto': MultipartFile(image, filename: image.path.split('/').last),
    });

    try {
      return await post(
        '${BaseUrl.updatePost}/$id',
        form,
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(
        statusCode: BaseUrl.serverError,
        statusText: 'Network Error: ${e.toString()}',
      );
    }
  }

  Future<Response> deletePost(int id) async {
    try {
      return await delete(
        '${BaseUrl.deletePost}/$id',
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(
        statusCode: BaseUrl.serverError,
        statusText: 'Network Error: ${e.toString()}',
      );
    }
  }
}
