import '../../utils/api.dart';

class ContentList {
  bool status;
  String message;
  ContentPagination? data;

  ContentList({required this.status, required this.message, this.data});

  factory ContentList.fromJson(Map<String, dynamic> json) {
    return ContentList(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? ContentPagination.fromJson(json['data'])
          : null,
    );
  }
}

class ContentPagination {
  List<ContentData> data;
  int currentPage;
  int lastPage;
  int total;

  ContentPagination({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  factory ContentPagination.fromJson(Map<String, dynamic> json) {
    return ContentPagination(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => ContentData.fromJson(item))
              .toList() ??
          [],
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      total: json['total'] ?? 0,
    );
  }
}

class ContentData {
  int id;
  String title;
  String desc;
  String content;
  int contentCategoryId;
  String type;
  String cover;
  String? createdAt;
  String? updatedAt;
  ContentCategoryData? contentCategory;

  ContentData({
    required this.id,
    required this.title,
    required this.desc,
    required this.content,
    required this.contentCategoryId,
    required this.type,
    required this.cover,
    this.createdAt,
    this.updatedAt,
    this.contentCategory,
  });

  factory ContentData.fromJson(Map<String, dynamic> json) {
    return ContentData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      content: json['content'] ?? '',
      contentCategoryId: json['content_category_id'] ?? 0,
      type: json['type'] ?? '',
      cover: json['cover'] ?? '',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      contentCategory: json['content_category'] != null
          ? ContentCategoryData.fromJson(json['content_category'])
          : null,
    );
  }

  String get fullCoverUrl {
    if (cover.isEmpty) return '';
    if (cover.startsWith('http')) return cover;
    return '${BaseUrl.storageUrl}/$cover';
  }

  String get fullContentUrl {
    if (content.isEmpty) return '';
    if (content.startsWith('http')) return content;
    return '${BaseUrl.storageUrl}/$content';
  }
}

class ContentCategoryData {
  int id;
  String name;

  ContentCategoryData({required this.id, required this.name});

  factory ContentCategoryData.fromJson(Map<String, dynamic> json) {
    return ContentCategoryData(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
