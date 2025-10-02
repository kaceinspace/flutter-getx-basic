class BaseUrl {
  // Auth endpoints
  static String login = 'http://192.168.6.22:8000/api/login';
  // static String register =
  // 'http://192.168.6.22:8000/api/register';
  static String logout = 'http://192.168.6.22:8000/api/logout';

  // User profile
  static String profile = 'http://192.168.6.22:8000/api/profile';

  // Dashboard endpoints - sesuai struktur backend
  static String latestBooks = 'http://192.168.6.22:8000/api/books/latest';
  static String allBooks = 'http://192.168.6.22:8000/api/books';
  static String bookDetail =
      'http://192.168.6.22:8000/api/books/detail'; // + /{id}
  static String searchBooks = 'http://192.168.6.22:8000/api/books/search';
  static String categories = 'http://192.168.6.22:8000/api/books/categories';
  static String bookshelves = 'http://192.168.6.22:8000/api/books/bookshelves';

  // Posts endpoints (sesuai dengan yang lu punya)
  static String posts = 'http://192.168.6.22:8000/api/lates';
  static String createPost = 'http://192.168.6.22:8000/api/posts';
  static String updatePost = 'http://192.168.6.22:8000/api/posts';
  static String deletePost = 'http://192.168.6.22:8000/api/posts';

  // Storage URL untuk gambar
  static String storageUrl = 'http://192.168.6.22:8000/storage';

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
