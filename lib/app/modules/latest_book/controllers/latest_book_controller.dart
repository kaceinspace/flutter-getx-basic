import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rpl1getx/app/data/models/latests_book.dart';
import 'package:rpl1getx/app/services/latest_book_service.dart';

class LatestBookController extends GetxController {
  final LatestBookService _latestBookService = Get.put(LatestBookService());
  final box = GetStorage();

  // Observable data
  RxList<DataLatestBook> latestBooks = <DataLatestBook>[].obs;
  RxList<DataLatestBook> allBooks = <DataLatestBook>[].obs;
  RxList<DataLatestBook> searchResults = <DataLatestBook>[].obs;
  Rx<DataLatestBook?> selectedBook = Rx<DataLatestBook?>(null);

  // Loading states
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool isSearching = false.obs;
  RxString errorMessage = ''.obs;

  // Pagination
  RxInt currentPage = 1.obs;
  RxBool hasMoreData = true.obs;
  RxInt totalBooks = 0.obs;

  // Search
  RxString searchQuery = ''.obs;
  RxString selectedCategory = 'all'.obs;
  RxString selectedBookshelf = 'all'.obs;
  RxBool availableOnly = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLatestBooks();
  }

  // Load latest books
  Future<void> loadLatestBooks() async {
    try {
      isLoading(true);
      errorMessage('');

      final token = box.read('token');
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await _latestBookService.getLatestBooks(token);

      if (response.statusCode == 200 && response.body != null) {
        latestBooks.assignAll(response.body!.data);
        totalBooks(response.body!.data.length);
      } else {
        throw Exception(response.statusText ?? 'Failed to load latest books');
      }
    } catch (e) {
      errorMessage('Gagal memuat buku terbaru: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Gagal memuat buku terbaru',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading(false);
    }
  }

  // Load all books with pagination
  Future<void> loadAllBooks({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        currentPage(1);
        hasMoreData(true);
        allBooks.clear();
      }

      if (!hasMoreData.value && !isRefresh) return;

      isRefresh ? isLoading(true) : isLoadingMore(true);
      errorMessage('');

      final token = box.read('token');
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await _latestBookService.getAllBooks(
        token,
        page: currentPage.value,
        limit: 10,
      );

      if (response.statusCode == 200 && response.body != null) {
        final newBooks = response.body!.data;

        if (isRefresh) {
          allBooks.assignAll(newBooks);
        } else {
          allBooks.addAll(newBooks);
        }

        if (newBooks.length < 10) {
          hasMoreData(false);
        } else {
          currentPage(currentPage.value + 1);
        }

        totalBooks(allBooks.length);
      } else {
        throw Exception(response.statusText ?? 'Failed to load books');
      }
    } catch (e) {
      errorMessage('Gagal memuat buku: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Gagal memuat daftar buku',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading(false);
      isLoadingMore(false);
    }
  }

  // Search books
  Future<void> searchBooks(String query) async {
    try {
      if (query.trim().isEmpty) {
        searchResults.clear();
        searchQuery('');
        return;
      }

      isSearching(true);
      errorMessage('');
      searchQuery(query);

      final token = box.read('token');
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await _latestBookService.searchBooks(
        token,
        query: query,
        category: selectedCategory.value == 'all'
            ? null
            : selectedCategory.value,
        bookshelf: selectedBookshelf.value == 'all'
            ? null
            : selectedBookshelf.value,
        availableOnly: availableOnly.value,
      );

      if (response.statusCode == 200 && response.body != null) {
        searchResults.assignAll(response.body!.data);
      } else {
        throw Exception(response.statusText ?? 'Failed to search books');
      }
    } catch (e) {
      errorMessage('Gagal mencari buku: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Gagal mencari buku',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isSearching(false);
    }
  }

  // Get book detail
  Future<void> getBookDetail(int bookId) async {
    try {
      isLoading(true);
      errorMessage('');

      final token = box.read('token');
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final response = await _latestBookService.getBookDetail(token, bookId);

      if (response.statusCode == 200 && response.body != null) {
        selectedBook(response.body);
      } else {
        throw Exception(response.statusText ?? 'Failed to load book detail');
      }
    } catch (e) {
      errorMessage('Gagal memuat detail buku: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Gagal memuat detail buku',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading(false);
    }
  }

  // Refresh data
  Future<void> refreshData() async {
    await Future.wait([loadLatestBooks(), loadAllBooks(isRefresh: true)]);

    if (errorMessage.value.isEmpty) {
      Get.snackbar(
        'Berhasil',
        'Data berhasil diperbarui',
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    }
  }

  // Clear search
  void clearSearch() {
    searchQuery('');
    searchResults.clear();
    selectedCategory('all');
    selectedBookshelf('all');
    availableOnly(false);
  }

  // Filter methods
  void setCategory(String category) {
    selectedCategory(category);
    if (searchQuery.value.isNotEmpty) {
      searchBooks(searchQuery.value);
    }
  }

  void setBookshelf(String bookshelf) {
    selectedBookshelf(bookshelf);
    if (searchQuery.value.isNotEmpty) {
      searchBooks(searchQuery.value);
    }
  }

  void toggleAvailableOnly(bool value) {
    availableOnly(value);
    if (searchQuery.value.isNotEmpty) {
      searchBooks(searchQuery.value);
    }
  }

  // Favorite methods (dummy implementation)
  RxList<int> favoriteBookIds = <int>[].obs;

  void toggleFavorite(int bookId) {
    if (favoriteBookIds.contains(bookId)) {
      favoriteBookIds.remove(bookId);
      Get.snackbar(
        'Dihapus',
        'Buku dihapus dari favorit',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } else {
      favoriteBookIds.add(bookId);
      Get.snackbar(
        'Ditambahkan',
        'Buku ditambahkan ke favorit',
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
      );
    }
  }

  bool isFavorite(int bookId) {
    return favoriteBookIds.contains(bookId);
  }
}
