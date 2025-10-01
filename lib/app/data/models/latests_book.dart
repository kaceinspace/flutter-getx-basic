class LatestBook {
  String status;
  String message;
  List<DataLatestBook> data;

  LatestBook({required this.status, required this.message, required this.data});
}

class DataLatestBook {
  int id;
  String title;
  String slug;
  String isbn;
  String description;
  String cover;
  String author;
  String category;
  String bookshelf;
  dynamic stock;
  DateTime createdAt;

  DataLatestBook({
    required this.id,
    required this.title,
    required this.slug,
    required this.isbn,
    required this.description,
    required this.cover,
    required this.author,
    required this.category,
    required this.bookshelf,
    required this.stock,
    required this.createdAt,
  });
}
