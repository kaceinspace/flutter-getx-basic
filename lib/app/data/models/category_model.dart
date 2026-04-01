class CategoryList {
  bool status;
  String message;
  List<CategoryData> data;

  CategoryList({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryList.fromJson(Map<String, dynamic> json) {
    return CategoryList(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => CategoryData.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class CategoryData {
  int id;
  String name;
  String slug;
  int bookCount;

  CategoryData({
    required this.id,
    required this.name,
    required this.slug,
    required this.bookCount,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      bookCount: json['book_count'] ?? 0,
    );
  }
}
