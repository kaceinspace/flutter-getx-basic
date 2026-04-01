class ContentModel {
  final int id;
  final String title;
  final String? desc;
  final String? content; // URL/path to video or PDF
  final String type; // 'video' or 'pdf'
  final String? cover;
  final ContentCategoryModel? contentCategory;

  ContentModel({
    required this.id,
    required this.title,
    this.desc,
    this.content,
    required this.type,
    this.cover,
    this.contentCategory,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      desc: json['desc'],
      content: json['content'],
      type: json['type'] ?? '',
      cover: json['cover'],
      contentCategory: json['content_category'] != null
          ? ContentCategoryModel.fromJson(json['content_category'])
          : null,
    );
  }
}

class ContentCategoryModel {
  final int id;
  final String name;

  ContentCategoryModel({required this.id, required this.name});

  factory ContentCategoryModel.fromJson(Map<String, dynamic> json) {
    return ContentCategoryModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}
