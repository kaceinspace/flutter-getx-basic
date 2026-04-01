import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rpl1getx/app/services/cart_service.dart';
import 'package:rpl1getx/app/utils/api.dart';
import 'package:rpl1getx/app/utils/api_helper.dart';

class BookDetailController extends GetxController with GetxServiceMixin {
  final _connect = GetConnect();
  final _cartService = CartService();
  final box = GetStorage();

  RxMap<String, dynamic> bookData = <String, dynamic>{}.obs;
  RxList<dynamic> relatedBooks = <dynamic>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _connect.onInit();
    _cartService.onInit();
    final slug = Get.arguments as String?;
    if (slug != null) {
      loadBookDetail(slug);
    }
  }

  Future<void> loadBookDetail(String slug) async {
    try {
      isLoading(true);
      final response = await _connect.get(
        '${BaseUrl.bookDetail}/$slug',
        headers: ApiHelper.getAuthHeaders(),
      );
      if (response.statusCode == 200 && response.body != null) {
        final data = response.body['data'];
        if (data != null) {
          bookData.value = data['book'] is Map<String, dynamic>
              ? data['book']
              : {};
          relatedBooks.assignAll(data['related_books'] ?? []);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat detail buku',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> addToCart() async {
    final bookId = bookData['id'];
    if (bookId != null) {
      final response = await _cartService.addToCart(bookId, 1);
      if (response.statusCode == 201) {
        Get.snackbar(
          'Berhasil',
          'Buku ditambahkan ke keranjang',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
        );
      } else {
        final msg =
            response.body?['message'] ?? 'Gagal menambahkan ke keranjang';
        Get.snackbar(
          'Info',
          msg,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    }
  }

  String get coverUrl {
    final cover = bookData['cover'] ?? '';
    if (cover.toString().isEmpty) return '';
    if (cover.toString().startsWith('http')) return cover;
    return '${BaseUrl.storageUrl}/$cover';
  }

  bool get isAvailable => (bookData['quantity'] ?? 0) > 0;
}
