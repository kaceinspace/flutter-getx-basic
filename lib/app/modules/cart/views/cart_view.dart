import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/utils/api.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Header
          _buildHeader(),

          // Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1E3A8A)),
                );
              }

              return Stack(
                children: [
                  // Scrollable content
                  RefreshIndicator(
                    onRefresh: controller.fetchCart,
                    color: const Color(0xFF1E3A8A),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 180),
                      children: [
                        // Info banner
                        _buildInfoBanner(),
                        const SizedBox(height: 20),

                        // Cart items or empty state
                        if (controller.cartItems.isEmpty)
                          _buildEmptyState()
                        else ...[
                          ...controller.cartItems.map(
                            (item) => _buildCartItem(item),
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryCard(),
                        ],
                      ],
                    ),
                  ),

                  // Borrow button
                  if (controller.cartItems.isNotEmpty) _buildBorrowButton(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(Get.context!).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
      ),
      child: const Row(
        children: [
          SizedBox(width: 40),
          Expanded(
            child: Text(
              'KERANJANG',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E3A8A),
                letterSpacing: -0.5,
              ),
            ),
          ),
          SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 20,
            color: Color(0xFF2563EB),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Maksimal peminjaman adalah 3 buku dengan durasi 7 hari kalender.',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E40AF),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 48,
              color: Color(0xFFCBD5E1),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'KERANJANG KOSONG',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: Color(0xFF94A3B8),
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItemModel item) {
    final coverUrl = item.book.cover != null && item.book.cover!.isNotEmpty
        ? '${BaseUrl.storageUrl}/${item.book.cover}'
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Book cover
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: SizedBox(
                width: 72,
                height: 90,
                child: coverUrl != null
                    ? Image.network(
                        coverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildCoverPlaceholder(),
                      )
                    : _buildCoverPlaceholder(),
              ),
            ),
            const SizedBox(width: 14),

            // Book info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (item.book.category?.name ?? 'Buku').toUpperCase(),
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF2563EB),
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.book.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.book.author?.name ?? '-',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),

            // Delete button
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _showDeleteConfirm(item),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    size: 22,
                    color: Colors.red.shade200,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverPlaceholder() {
    return Container(
      color: const Color(0xFFE2E8F0),
      child: const Center(
        child: Icon(
          Icons.menu_book_rounded,
          color: Color(0xFF94A3B8),
          size: 28,
        ),
      ),
    );
  }

  void _showDeleteConfirm(CartItemModel item) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Hapus Buku?',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        content: Text(
          'Hapus "${item.book.title}" dari keranjang?',
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.removeItem(item.id);
            },
            child: Text(
              'Hapus',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.red.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'RINGKASAN PINJAMAN',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E3A8A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryRow('Total Buku', '${controller.cartItems.length} Buku'),
          const SizedBox(height: 10),
          _buildSummaryRow('Durasi', '7 Hari'),
          const SizedBox(height: 14),

          // Divider dashed
          Row(
            children: List.generate(
              40,
              (i) => Expanded(
                child: Container(
                  height: 1,
                  color: i.isEven
                      ? const Color(0xFFE2E8F0)
                      : Colors.transparent,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Return date
          Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                size: 16,
                color: Color(0xFFD97706),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'KEMBALI PADA: ${controller.returnDateFormatted}'
                      .toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFD97706),
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF94A3B8),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E3A8A),
          ),
        ),
      ],
    );
  }

  Widget _buildBorrowButton() {
    return Positioned(
      bottom: 16,
      left: 20,
      right: 20,
      child: Obx(
        () => AnimatedOpacity(
          opacity: controller.cartItems.isNotEmpty ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: GestureDetector(
            onTap: controller.isBorrowing.value
                ? null
                : () => _showBorrowConfirm(),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (controller.isBorrowing.value)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  else ...[
                    const Text(
                      'PINJAM SEKARANG',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 20,
                      color: Color(0xFFFBBF24),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBorrowConfirm() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Konfirmasi Peminjaman',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        content: Text(
          'Pinjam ${controller.cartItems.length} buku? Batas pengembalian ${controller.returnDateFormatted}.',
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Batal',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.borrowAll();
            },
            child: const Text(
              'Pinjam',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E3A8A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
