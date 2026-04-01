import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/routes/app_pages.dart';
import 'package:rpl1getx/app/utils/api.dart';
import '../controllers/book_detail_controller.dart';

class BookDetailView extends GetView<BookDetailController> {
  const BookDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.bookData.isEmpty) {
          return const Center(child: Text('Buku tidak ditemukan'));
        }
        return CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(child: _buildBookInfo()),
            if (controller.relatedBooks.isNotEmpty)
              SliverToBoxAdapter(child: _buildRelatedBooks()),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.bookData.isEmpty) return const SizedBox();
        return _buildBottomBar();
      }),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: const Color(0xFF1E3A8A),
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
            ),
          ),
          child: Center(
            child: controller.coverUrl.isNotEmpty
                ? Hero(
                    tag: 'book-${controller.bookData['id']}',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        controller.coverUrl,
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholderCover(),
                      ),
                    ),
                  )
                : _buildPlaceholderCover(),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () => Get.toNamed(Routes.CART),
        ),
      ],
    );
  }

  Widget _buildPlaceholderCover() {
    return Container(
      height: 200,
      width: 140,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.book, color: Colors.white, size: 60),
    );
  }

  Widget _buildBookInfo() {
    final book = controller.bookData;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book['title'] ?? '',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 8),
          if (book['author'] != null)
            _buildInfoRow(
              Icons.person,
              'Penulis',
              book['author']['name'] ?? '',
            ),
          _buildInfoRow(
            Icons.category,
            'Kategori',
            book['category']?['name'] ?? '',
          ),
          _buildInfoRow(Icons.shelves, 'Rak', book['bookshelf']?['name'] ?? ''),
          _buildInfoRow(Icons.qr_code, 'Kode Buku', book['book_code'] ?? ''),
          _buildInfoRow(Icons.business, 'Penerbit', book['publisher'] ?? ''),
          _buildInfoRow(
            Icons.calendar_today,
            'Tahun Terbit',
            book['publication_year'] ?? '',
          ),
          if (book['isbn'] != null && book['isbn'].toString().isNotEmpty)
            _buildInfoRow(Icons.numbers, 'ISBN', book['isbn']),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: controller.isAvailable
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  controller.isAvailable
                      ? 'Tersedia (${book['quantity']})'
                      : 'Tidak Tersedia',
                  style: TextStyle(
                    color: controller.isAvailable
                        ? const Color(0xFF10B981)
                        : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (book['desc'] != null && book['desc'].toString().isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'Deskripsi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              book['desc'],
              style: TextStyle(color: Colors.grey[700], height: 1.5),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    if (value.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[500]),
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedBooks() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Buku Terkait',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.relatedBooks.length,
              itemBuilder: (context, index) {
                final related = controller.relatedBooks[index];
                return _buildRelatedBookCard(related);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedBookCard(dynamic book) {
    final cover = book['cover'] ?? '';
    final coverUrl = cover.toString().startsWith('http')
        ? cover
        : '${BaseUrl.storageUrl}/$cover';
    return GestureDetector(
      onTap: () => Get.offNamed(Routes.BOOK_DETAIL, arguments: book['slug']),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                coverUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 100,
                  color: const Color(0xFF1E3A8A).withOpacity(0.1),
                  child: const Center(
                    child: Icon(Icons.book, color: Color(0xFF1E3A8A)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book['title'] ?? '',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    book['author']?['name'] ?? '',
                    style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.isAvailable
                    ? () => controller.addToCart()
                    : null,
                icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                label: const Text(
                  'Tambah ke Keranjang',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  disabledBackgroundColor: Colors.grey[400],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
