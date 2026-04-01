class BaseUrl {
  static const String _base = 'http://192.168.0.100:8000';
  static String get base => _base;

  // Auth endpoints
  static String login = '$_base/api/login';
  static String logout = '$_base/api/logout';
  static String profile = '$_base/api/profile';

  // Library endpoints
  static String home = '$_base/api/home';
  static String categories = '$_base/api/categories';
  static String latestBooks = '$_base/api/books/latest';
  static String books = '$_base/api/books';
  static String booksSearch = '$_base/api/books/search';
  static String booksByCategory = '$_base/api/books/category'; // + /{slug}
  static String borrowHistory = '$_base/api/borrows/history';
  static String pdfs = '$_base/api/pdfs';
  static String videos = '$_base/api/videos';

  // Cart endpoints
  static String cart = '$_base/api/cart';
  static String cartAdd = '$_base/api/cart/add'; // + /{bookId}
  static String cartUpdate = '$_base/api/cart/update'; // + /{id}
  static String cartDelete = '$_base/api/cart/delete'; // + /{id}
  static String borrow = '$_base/api/borrow';

  // Storage URL untuk gambar
  static String storageUrl = '$_base/storage';

  // Headers
  static Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // Headers with auth token
  static Map<String, String> authHeaders(String token) => {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // Status codes
  static int success = 200;
  static int created = 201;
  static int badRequest = 400;
  static int unauthorized = 401;
  static int notFound = 404;
  static int serverError = 500;
}
