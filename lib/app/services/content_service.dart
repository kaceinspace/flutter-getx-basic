import 'package:get/get.dart';
import '../utils/api.dart';
import '../utils/api_helper.dart';

class ContentService extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultContentType = 'application/json';
    super.onInit();
  }

  Future<Response> getPdfs({int page = 1}) async {
    try {
      return await get(
        '${BaseUrl.pdfs}?page=$page',
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Network Error: $e');
    }
  }

  Future<Response> getPdfDetail(int id) async {
    try {
      return await get(
        '${BaseUrl.pdfs}/$id',
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Network Error: $e');
    }
  }

  Future<Response> getVideos({int page = 1}) async {
    try {
      return await get(
        '${BaseUrl.videos}?page=$page',
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Network Error: $e');
    }
  }

  Future<Response> getVideoDetail(int id) async {
    try {
      return await get(
        '${BaseUrl.videos}/$id',
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Network Error: $e');
    }
  }

  Future<Response> getCategories() async {
    try {
      return await get(BaseUrl.categories, headers: ApiHelper.getAuthHeaders());
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Network Error: $e');
    }
  }

  Future<Response> getBookshelves() async {
    try {
      return await get(
        BaseUrl.bookshelves,
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Network Error: $e');
    }
  }

  Future<Response> getHome() async {
    try {
      return await get(BaseUrl.home, headers: ApiHelper.getAuthHeaders());
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Network Error: $e');
    }
  }

  Future<Response> getBooksByCategory(String slug, {int page = 1}) async {
    try {
      return await get(
        '${BaseUrl.filterByCategory}/$slug?page=$page',
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Network Error: $e');
    }
  }

  Future<Response> getBooksByBookshelf(String slug, {int page = 1}) async {
    try {
      return await get(
        '${BaseUrl.filterByBookshelf}/$slug?page=$page',
        headers: ApiHelper.getAuthHeaders(),
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: 'Network Error: $e');
    }
  }
}
