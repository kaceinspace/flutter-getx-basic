import 'dart:convert';

import 'package:get/get.dart';
import 'package:rpl1getx/app/data/models/book_model.dart';
import 'package:rpl1getx/app/services/library_service.dart';

class CategoryController extends GetxController {
  final _libraryService = Get.put(LibraryService());

  final isLoading = true.obs;
  final categories = <CategoryModel>[].obs;
  final selectedCategory = Rxn<CategoryModel>();
  final booksForCategory = <BookModel>[].obs;
  final isLoadingBooks = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      final response = await _libraryService.getCategories();
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        if (body['status'] == true && body['data'] != null) {
          categories.value = (body['data'] as List)
              .map((c) => CategoryModel.fromJson(c))
              .toList();
        }
      }
    } catch (_) {
    } finally {
      isLoading(false);
    }
  }

  Future<void> selectCategory(CategoryModel category) async {
    selectedCategory.value = category;
    try {
      isLoadingBooks(true);
      booksForCategory.clear();
      final response = await _libraryService.getBooksByCategory(category.slug);
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        if (body['status'] == true && body['data'] != null) {
          final data = body['data'];
          final bookList = data['books'];
          final list = bookList is List ? bookList : (bookList?['data'] ?? []);
          booksForCategory.value = (list as List)
              .map((b) => BookModel.fromJson(b))
              .toList();
        }
      }
    } catch (_) {
    } finally {
      isLoadingBooks(false);
    }
  }

  void clearSelection() {
    selectedCategory.value = null;
    booksForCategory.clear();
  }
}
