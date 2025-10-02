import 'package:get/get.dart';
import 'package:rpl1getx/app/data/models/latests_book.dart';
import 'package:rpl1getx/app/utils/api.dart';

class LatestBookService extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultContentType = 'application/json';
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers.addAll(BaseUrl.defaultHeaders);
      return request;
    });
    super.onInit();
  }

  // Get latest books
  Future<Response<LatestBook>> getLatestBooks(String token) async {
    try {
      final response = await get(
        BaseUrl.latestBooks,
        headers: BaseUrl.authHeaders(token),
      );

      if (response.statusCode == BaseUrl.success && response.body != null) {
        final latestBook = LatestBook.fromJson(response.body);
        return Response(
          statusCode: BaseUrl.success,
          body: latestBook,
          statusText: 'Success',
        );
      } else {
        return Response(
          statusCode: response.statusCode,
          statusText: response.statusText ?? 'Failed to fetch latest books',
        );
      }
    } catch (e) {
      print('Latest Book Service Error: $e');
      return Response(
        statusCode: BaseUrl.serverError,
        statusText: 'Connection error: $e',
      );
    }
  }

  // Get all books with pagination
  Future<Response<LatestBook>> getAllBooks(
    String token, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await get(
        '${BaseUrl.allBooks}?page=$page&limit=$limit',
        headers: BaseUrl.authHeaders(token),
      );

      if (response.statusCode == BaseUrl.success && response.body != null) {
        final books = LatestBook.fromJson(response.body);
        return Response(
          statusCode: BaseUrl.success,
          body: books,
          statusText: 'Success',
        );
      } else {
        return Response(
          statusCode: response.statusCode,
          statusText: response.statusText ?? 'Failed to fetch books',
        );
      }
    } catch (e) {
      print('All Books Service Error: $e');
      return Response(
        statusCode: BaseUrl.serverError,
        statusText: 'Connection error: $e',
      );
    }
  }

  // Get book detail
  Future<Response<DataLatestBook>> getBookDetail(
    String token,
    int bookId,
  ) async {
    try {
      final response = await get(
        '${BaseUrl.bookDetail}/$bookId',
        headers: BaseUrl.authHeaders(token),
      );

      if (response.statusCode == BaseUrl.success && response.body != null) {
        final book = DataLatestBook.fromJson(response.body['data']);
        return Response(
          statusCode: BaseUrl.success,
          body: book,
          statusText: 'Success',
        );
      } else {
        return Response(
          statusCode: response.statusCode,
          statusText: response.statusText ?? 'Failed to fetch book detail',
        );
      }
    } catch (e) {
      print('Book Detail Service Error: $e');
      return Response(
        statusCode: BaseUrl.serverError,
        statusText: 'Connection error: $e',
      );
    }
  }

  // Search books
  Future<Response<LatestBook>> searchBooks(
    String token, {
    required String query,
    String? category,
    String? bookshelf,
    bool? availableOnly,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      Map<String, String> queryParams = {
        'q': query,
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (bookshelf != null && bookshelf.isNotEmpty) {
        queryParams['bookshelf'] = bookshelf;
      }
      if (availableOnly == true) {
        queryParams['available'] = 'true';
      }

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');

      final response = await get(
        '${BaseUrl.searchBooks}?$queryString',
        headers: BaseUrl.authHeaders(token),
      );

      if (response.statusCode == BaseUrl.success && response.body != null) {
        final books = LatestBook.fromJson(response.body);
        return Response(
          statusCode: BaseUrl.success,
          body: books,
          statusText: 'Success',
        );
      } else {
        return Response(
          statusCode: response.statusCode,
          statusText: response.statusText ?? 'Failed to search books',
        );
      }
    } catch (e) {
      print('Search Books Service Error: $e');
      return Response(
        statusCode: BaseUrl.serverError,
        statusText: 'Connection error: $e',
      );
    }
  }
}
