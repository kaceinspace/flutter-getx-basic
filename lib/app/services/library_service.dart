import 'package:get/get.dart';
import '../utils/api.dart';

class LibraryService extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 30);
    super.onInit();
  }

  Future<Response> getBooks({int page = 1}) {
    return get('${BaseUrl.books}?page=$page', headers: BaseUrl.defaultHeaders);
  }

  Future<Response> getCategories() {
    return get(BaseUrl.categories, headers: BaseUrl.defaultHeaders);
  }

  Future<Response> searchBooks(String keyword) {
    return get(
      '${BaseUrl.booksSearch}?search=$keyword',
      headers: BaseUrl.defaultHeaders,
    );
  }

  Future<Response> getBooksByCategory(String slug) {
    return get(
      '${BaseUrl.booksByCategory}/$slug',
      headers: BaseUrl.defaultHeaders,
    );
  }

  Future<Response> getVideos({int page = 1}) {
    return get(
      '${BaseUrl.videos}?page=$page',
      headers: BaseUrl.defaultHeaders,
    );
  }

  Future<Response> getPdfs({int page = 1}) {
    return get(
      '${BaseUrl.pdfs}?page=$page',
      headers: BaseUrl.defaultHeaders,
    );
  }
}
