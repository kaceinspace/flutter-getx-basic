class BookshelfList {
  bool status;
  String message;
  List<BookshelfData> data;

  BookshelfList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BookshelfList.fromJson(Map<String, dynamic> json) {
    return BookshelfList(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => BookshelfData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class BookshelfData {
  int id;
  String name;
  String slug;
  int bookCount;

  BookshelfData({
    required this.id,
    required this.name,
    required this.slug,
    required this.bookCount,
  });

  factory BookshelfData.fromJson(Map<String, dynamic> json) {
    return BookshelfData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      bookCount: json['book_count'] ?? 0,
    );
  }
}
