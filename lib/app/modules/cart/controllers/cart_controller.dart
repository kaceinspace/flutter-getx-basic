import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/data/models/cart_model.dart';
import 'package:rpl1getx/app/services/cart_service.dart';

class CartController extends GetxController {
  final CartService _cartService = Get.put(CartService());

  RxList<CartData> cartItems = <CartData>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      isLoading(true);
      final response = await _cartService.getCart();
      if (response.statusCode == 200 && response.body != null) {
        final parsed = CartList.fromJson(response.body);
        cartItems.assignAll(parsed.data);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat keranjang',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> addToCart(int bookId, {int quantity = 1}) async {
    try {
      final response = await _cartService.addToCart(bookId, quantity);
      if (response.statusCode == 201) {
        Get.snackbar(
          'Berhasil',
          'Buku ditambahkan ke keranjang',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
        );
        await loadCart();
      } else {
        final msg = response.body?['message'] ?? 'Gagal menambahkan';
        Get.snackbar(
          'Gagal',
          msg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateCartItem(int cartId, int quantity) async {
    try {
      final response = await _cartService.updateCart(cartId, quantity);
      if (response.statusCode == 200) {
        await loadCart();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> removeFromCart(int cartId) async {
    try {
      final response = await _cartService.deleteFromCart(cartId);
      if (response.statusCode == 200) {
        cartItems.removeWhere((item) => item.id == cartId);
        Get.snackbar(
          'Berhasil',
          'Buku dihapus dari keranjang',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> borrowFromCart() async {
    try {
      isLoading(true);
      final response = await _cartService.borrowFromCart();
      if (response.statusCode == 201) {
        cartItems.clear();
        Get.snackbar(
          'Berhasil',
          response.body?['message'] ?? 'Peminjaman berhasil dibuat',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      } else {
        final msg = response.body?['message'] ?? 'Gagal meminjam';
        Get.snackbar(
          'Gagal',
          msg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  int get totalItems => cartItems.length;
}
