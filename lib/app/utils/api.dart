class BaseUrl {
  static const String _base = 'http://10.0.2.2:8000';
  static String get base => _base;

  // Auth endpoints
  static String login = '$_base/api/login';
  static String logout = '$_base/api/logout';

  // User profile
  static String profile = '$_base/api/profile';
  static String updateProfile = '$_base/api/profile';
  static String updatePassword = '$_base/api/profile/password';

  // Home / Dashboard
  static String home = '$_base/api/home';

  // Books endpoints
  static String latestBooks = '$_base/api/books/latest';
  static String allBooks = '$_base/api/books';
  static String bookDetail = '$_base/api/books/detail'; // + /{slug}
  static String searchBooks = '$_base/api/books/search';
  static String filterByCategory = '$_base/api/books/category'; // + /{slug}
  static String filterByBookshelf = '$_base/api/books/bookshelf'; // + /{slug}

  // Categories & Bookshelves
  static String categories = '$_base/api/categories';
  static String bookshelves = '$_base/api/bookshelves';

  // Cart endpoints
  static String cart = '$_base/api/cart';
  static String cartAdd = '$_base/api/cart/add'; // + /{bookId}
  static String cartUpdate = '$_base/api/cart/update'; // + /{id}
  static String cartDelete = '$_base/api/cart/delete'; // + /{id}

  // Borrow endpoints
  static String borrow = '$_base/api/borrow';
  static String borrowHistory = '$_base/api/borrows/history';

  // Content (PDF & Video)
  static String pdfs = '$_base/api/pdfs';
  static String videos = '$_base/api/videos';

  // Reading Bookmarks
  static String bookmarkSave = '$_base/api/bookmarks/save';
  static String bookmarkGet = '$_base/api/bookmarks'; // + /{contentId}

  // Posts endpoints
  static String posts = '$_base/api/lates';
  static String createPost = '$_base/api/posts';
  static String updatePost = '$_base/api/posts';
  static String deletePost = '$_base/api/posts';

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
