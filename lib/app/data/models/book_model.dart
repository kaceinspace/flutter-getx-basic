class BookModel {
  final int id;
  final String title;
  final String slug;
  final String? cover;
  final String? publisher;
  final String? publicationYear;
  final String? isbn;
  final String? desc;
  final String? price;
  final int? quantity;
  final String? classification;
  final AuthorModel? author;
  final CategoryModel? category;
  final BookshelfModel? bookshelf;

  BookModel({
    required this.id,
    required this.title,
    required this.slug,
    this.cover,
    this.publisher,
    this.publicationYear,
    this.isbn,
    this.desc,
    this.price,
    this.quantity,
    this.classification,
    this.author,
    this.category,
    this.bookshelf,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      cover: json['cover'],
      publisher: json['publisher'],
      publicationYear: json['publication_year']?.toString(),
      isbn: json['isbn'],
      desc: json['desc'],
      price: json['price']?.toString(),
      quantity: json['quantity'],
      classification: json['classification'],
      author: json['author'] != null
          ? AuthorModel.fromJson(json['author'])
          : null,
      category: json['category'] != null
          ? CategoryModel.fromJson(json['category'])
          : null,
      bookshelf: json['bookshelf'] != null
          ? BookshelfModel.fromJson(json['bookshelf'])
          : null,
    );
  }
}

class AuthorModel {
  final int id;
  final String name;

  AuthorModel({required this.id, required this.name});

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class CategoryModel {
  final int id;
  final String name;
  final String slug;
  final int? bookCount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.bookCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      bookCount: json['book_count'],
    );
  }
}

class BookshelfModel {
  final int id;
  final String name;
  final String slug;

  BookshelfModel({required this.id, required this.name, required this.slug});

  factory BookshelfModel.fromJson(Map<String, dynamic> json) {
    return BookshelfModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}

class HomeStatsModel {
  final int totalBooks;
  final int totalPdfs;
  final int totalVideos;

  HomeStatsModel({
    required this.totalBooks,
    required this.totalPdfs,
    required this.totalVideos,
  });

  factory HomeStatsModel.fromJson(Map<String, dynamic> json) {
    return HomeStatsModel(
      totalBooks: json['total_books'] ?? 0,
      totalPdfs: json['total_pdfs'] ?? 0,
      totalVideos: json['total_videos'] ?? 0,
    );
  }
}
