import '../../utils/api.dart';

class LatestBook {
  bool status;
  String message;
  List<DataLatestBook> data;

  LatestBook({required this.status, required this.message, required this.data});

  factory LatestBook.fromJson(Map<String, dynamic> json) {
    return LatestBook(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => DataLatestBook.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class DataLatestBook {
  int id;
  String title;
  String slug;
  String bookCode;
  String publisher;
  String publicationYear;
  String isbn;
  String desc;
  String cover;
  int price;
  int quantity;
  dynamic classification;
  DateTime createdAt;
  DateTime updatedAt;
  String authorName;
  String categoryName;
  String bookshelfName;

  DataLatestBook({
    required this.id,
    required this.title,
    required this.slug,
    required this.bookCode,
    required this.publisher,
    required this.publicationYear,
    required this.isbn,
    required this.desc,
    required this.cover,
    required this.price,
    required this.quantity,
    required this.classification,
    required this.createdAt,
    required this.updatedAt,
    required this.authorName,
    required this.categoryName,
    required this.bookshelfName,
  });

  factory DataLatestBook.fromJson(Map<String, dynamic> json) {
    return DataLatestBook(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      bookCode: json['book_code'] ?? '',
      publisher: json['publisher'] ?? '',
      publicationYear: json['publication_year'] ?? '',
      isbn: json['isbn'] ?? '',
      desc: json['desc'] ?? '',
      cover: json['cover'] ?? '',
      price: json['price'] ?? 0,
      quantity: json['quantity'] ?? 0,
      classification: json['classification'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      authorName: json['author_name'] ?? '',
      categoryName: json['category_name'] ?? '',
      bookshelfName: json['bookshelf_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'book_code': bookCode,
      'publisher': publisher,
      'publication_year': publicationYear,
      'isbn': isbn,
      'desc': desc,
      'cover': cover,
      'price': price,
      'quantity': quantity,
      'classification': classification,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'author_name': authorName,
      'category_name': categoryName,
      'bookshelf_name': bookshelfName,
    };
  }

  // Helper getter untuk cover URL lengkap
  String get fullCoverUrl {
    if (cover.isEmpty) return '';
    if (cover.startsWith('http')) return cover;
    return '${BaseUrl.storageUrl}/$cover';
  }

  // Helper getter untuk status ketersediaan
  bool get isAvailable => quantity > 0;

  // Helper untuk format harga
  String get formattedPrice {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  // Helper untuk format tanggal
  String get formattedCreatedAt {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}
