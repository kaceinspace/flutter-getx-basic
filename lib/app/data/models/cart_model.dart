import '../../utils/api.dart';

class CartList {
  bool status;
  String message;
  List<CartData> data;

  CartList({required this.status, required this.message, required this.data});

  factory CartList.fromJson(Map<String, dynamic> json) {
    return CartList(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => CartData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class CartData {
  int id;
  int userId;
  int bookId;
  int quantity;
  CartBookData? book;

  CartData({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.quantity,
    this.book,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      bookId: json['book_id'] ?? 0,
      quantity: json['quantity'] ?? 1,
      book: json['book'] != null ? CartBookData.fromJson(json['book']) : null,
    );
  }
}

class CartBookData {
  int id;
  String title;
  String slug;
  String cover;
  int price;
  int quantity;
  String? authorName;

  CartBookData({
    required this.id,
    required this.title,
    required this.slug,
    required this.cover,
    required this.price,
    required this.quantity,
    this.authorName,
  });

  factory CartBookData.fromJson(Map<String, dynamic> json) {
    return CartBookData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      cover: json['cover'] ?? '',
      price: json['price'] ?? 0,
      quantity: json['quantity'] ?? 0,
      authorName: json['author']?['name'],
    );
  }

  String get fullCoverUrl {
    if (cover.isEmpty) return '';
    if (cover.startsWith('http')) return cover;
    return '${BaseUrl.storageUrl}/$cover';
  }
}
