import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/data/models/book_model.dart';
import 'package:rpl1getx/app/data/models/content_model.dart';
import 'package:rpl1getx/app/services/cart_service.dart';
import 'package:rpl1getx/app/services/library_service.dart';

class HomeController extends GetxController {
  final _libraryService = Get.put(LibraryService());
  final _cartService = Get.put(CartService());

  final searchController = TextEditingController();

  final isLoading = true.obs;
  final isSearching = false.obs;
  final books = <BookModel>[].obs;
  final videos = <ContentModel>[].obs;
  final pdfs = <ContentModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final activeCategory = 'Semua'.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchInitialData() async {
    try {
      isLoading(true);
      await Future.wait([
        _fetchBooks(),
        _fetchCategories(),
        _fetchVideos(),
        _fetchPdfs(),
      ]);
    } finally {
      isLoading(false);
    }
  }

  Future<void> _fetchBooks() async {
    try {
      final response = await _libraryService.getBooks();
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        if (body['status'] == true && body['data'] != null) {
          final data = body['data'];
          // Paginated response: data is the paginator object with 'data' key
          final bookList = data is List ? data : (data['data'] ?? []);
          books.value = (bookList as List)
              .map((b) => BookModel.fromJson(b))
              .toList();
        }
      }
    } catch (_) {}
  }

  Future<void> _fetchCategories() async {
    try {
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
    } catch (_) {}
  }

  Future<void> _fetchVideos() async {
    try {
      final response = await _libraryService.getVideos();
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        if (body['status'] == true && body['data'] != null) {
          final data = body['data'];
          final list = data is List ? data : (data['data'] ?? []);
          videos.value = (list as List)
              .map((v) => ContentModel.fromJson(v))
              .toList();
        }
      }
    } catch (_) {}
  }

  Future<void> _fetchPdfs() async {
    try {
      final response = await _libraryService.getPdfs();
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        if (body['status'] == true && body['data'] != null) {
          final data = body['data'];
          final list = data is List ? data : (data['data'] ?? []);
          pdfs.value = (list as List)
              .map((p) => ContentModel.fromJson(p))
              .toList();
        }
      }
    } catch (_) {}
  }

  void selectCategory(String categoryName) {
    activeCategory.value = categoryName;
    if (categoryName == 'Semua') {
      _fetchBooks();
    } else {
      final cat = categories.firstWhereOrNull((c) => c.name == categoryName);
      if (cat != null) {
        _fetchBooksByCategory(cat.slug);
      }
    }
  }

  Future<void> _fetchBooksByCategory(String slug) async {
    try {
      isLoading(true);
      final response = await _libraryService.getBooksByCategory(slug);
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        if (body['status'] == true && body['data'] != null) {
          final data = body['data'];
          final bookList = data['books'];
          final list = bookList is List ? bookList : (bookList?['data'] ?? []);
          books.value = (list as List)
              .map((b) => BookModel.fromJson(b))
              .toList();
        }
      }
    } catch (_) {
    } finally {
      isLoading(false);
    }
  }

  Future<void> searchBooks(String query) async {
    searchQuery.value = query;
    if (query.isEmpty) {
      activeCategory.value = 'Semua';
      await _fetchBooks();
      return;
    }
    try {
      isSearching(true);
      final response = await _libraryService.searchBooks(query);
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        if (body['status'] == true && body['data'] != null) {
          final data = body['data'];
          final bookList = data['books'];
          final list = bookList is List ? bookList : (bookList?['data'] ?? []);
          books.value = (list as List)
              .map((b) => BookModel.fromJson(b))
              .toList();
        }
      }
    } catch (_) {
    } finally {
      isSearching(false);
    }
  }

  Future<void> addToCart(BookModel book) async {
    try {
      final response = await _cartService.addToCart(book.id);
      final body = response.body is String
          ? jsonDecode(response.body)
          : response.body;

      if (response.statusCode == 201 && body['status'] == true) {
        Get.snackbar(
          'Berhasil',
          '${book.title} ditambahkan ke keranjang',
          backgroundColor: const Color(0xFF1E3A8A),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      } else if (response.statusCode == 409) {
        Get.snackbar(
          'Info',
          body['message'] ?? 'Buku sudah ada di keranjang',
          backgroundColor: const Color(0xFFD97706),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        Get.snackbar(
          'Gagal',
          body['message'] ?? 'Gagal menambahkan ke keranjang',
          backgroundColor: Colors.red.shade600,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (_) {
      Get.snackbar(
        'Error',
        'Gagal terhubung ke server',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> refreshData() async {
    activeCategory.value = 'Semua';
    searchController.clear();
    searchQuery.value = '';
    await fetchInitialData();
  }
}
