import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/data/models/book_model.dart';
import 'package:rpl1getx/app/services/cart_service.dart';

class CartItemModel {
  final int id;
  final int bookId;
  final int quantity;
  final BookModel book;

  CartItemModel({
    required this.id,
    required this.bookId,
    required this.quantity,
    required this.book,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? 0,
      bookId: json['book_id'] ?? 0,
      quantity: json['quantity'] ?? 1,
      book: BookModel.fromJson(json['book'] ?? {}),
    );
  }
}

class CartController extends GetxController {
  final _cartService = Get.put(CartService());

  final isLoading = true.obs;
  final isBorrowing = false.obs;
  final cartItems = <CartItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  Future<void> fetchCart() async {
    try {
      isLoading(true);
      final response = await _cartService.getCart();

      if (response.statusCode == 200 && response.body != null) {
        final body = response.body is String
            ? jsonDecode(response.body)
            : response.body;
        if (body['status'] == true && body['data'] != null) {
          cartItems.value = (body['data'] as List)
              .map((item) => CartItemModel.fromJson(item))
              .toList();
        }
      }
    } catch (_) {
      Get.snackbar(
        'Error',
        'Gagal memuat keranjang',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> removeItem(int cartId) async {
    try {
      final response = await _cartService.deleteFromCart(cartId);
      final body = response.body is String
          ? jsonDecode(response.body)
          : response.body;

      if (response.statusCode == 200 && body['status'] == true) {
        cartItems.removeWhere((item) => item.id == cartId);
        Get.snackbar(
          'Berhasil',
          'Buku dihapus dari keranjang',
          backgroundColor: const Color(0xFF1E3A8A),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (_) {
      Get.snackbar(
        'Error',
        'Gagal menghapus buku',
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  Future<void> borrowAll() async {
    try {
      isBorrowing(true);
      final response = await _cartService.borrowFromCart();
      final body = response.body is String
          ? jsonDecode(response.body)
          : response.body;

      if (response.statusCode == 201 && body['status'] == true) {
        cartItems.clear();
        Get.snackbar(
          'Peminjaman Berhasil!',
          body['message'] ?? 'Menunggu persetujuan',
          backgroundColor: const Color(0xFF16A34A),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 4),
        );
      } else {
        Get.snackbar(
          'Gagal',
          body['message'] ?? 'Tidak dapat memproses peminjaman',
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
    } finally {
      isBorrowing(false);
    }
  }

  String get returnDateFormatted {
    final returnDate = DateTime.now().add(const Duration(days: 7));
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${returnDate.day} ${months[returnDate.month - 1]} ${returnDate.year}';
  }
}
