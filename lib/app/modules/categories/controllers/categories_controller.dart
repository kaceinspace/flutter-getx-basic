import 'package:get/get.dart';
import 'package:rpl1getx/app/data/models/category_model.dart';
import 'package:rpl1getx/app/data/models/bookshelf_model.dart';
import 'package:rpl1getx/app/services/content_service.dart';

class CategoriesController extends GetxController {
  final ContentService _contentService = Get.put(ContentService());

  RxList<CategoryData> categories = <CategoryData>[].obs;
  RxList<BookshelfData> bookshelves = <BookshelfData>[].obs;
  RxBool isLoading = false.obs;
  RxInt tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final type = Get.arguments as String?;
    if (type == 'bookshelf') tabIndex.value = 1;
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading(true);
      await Future.wait([_loadCategories(), _loadBookshelves()]);
    } finally {
      isLoading(false);
    }
  }

  Future<void> _loadCategories() async {
    try {
      final response = await _contentService.getCategories();
      if (response.statusCode == 200 && response.body != null) {
        final parsed = CategoryList.fromJson(response.body);
        categories.assignAll(parsed.data);
      }
    } catch (e) {
      // silently fail
    }
  }

  Future<void> _loadBookshelves() async {
    try {
      final response = await _contentService.getBookshelves();
      if (response.statusCode == 200 && response.body != null) {
        final parsed = BookshelfList.fromJson(response.body);
        bookshelves.assignAll(parsed.data);
      }
    } catch (e) {
      // silently fail
    }
  }
}
