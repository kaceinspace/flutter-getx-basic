import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  bool? success;
  List<DataPost>? data;
  String? message;

  Post({this.success, this.data, this.message});

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    success: json["success"],
    data: json["data"] == null
        ? []
        : List<DataPost>.from(json["data"]!.map((x) => DataPost.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "message": message,
  };
}

class DataPost {
  int? id;
  String? title;
  String? content;
  String? slug;
  int? status;
  String? foto;
  DateTime? createdAt;
  DateTime? updatedAt;

  DataPost({
    this.id,
    this.title,
    this.content,
    this.slug,
    this.status,
    this.foto,
    this.createdAt,
    this.updatedAt,
  });

  factory DataPost.fromJson(Map<String, dynamic> json) => DataPost(
    id: json["id"] is String ? int.tryParse(json["id"]) : json["id"],
    title: json["title"],
    content: json["content"],
    slug: json["slug"],
    status: json["status"] is String
        ? int.tryParse(json["status"])
        : json["status"],
    foto: json["foto"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "slug": slug,
    "status": status,
    "foto": foto,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
