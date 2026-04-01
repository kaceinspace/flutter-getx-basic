import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/routes/app_pages.dart';
import '../controllers/categories_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: controller.tabIndex.value,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text(
            'Kategori & Rak Buku',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1E3A8A),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: Color(0xFFFBBF24),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(icon: Icon(Icons.category), text: 'Kategori'),
              Tab(icon: Icon(Icons.shelves), text: 'Rak Buku'),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return TabBarView(
            children: [_buildCategoriesTab(), _buildBookshelvesTab()],
          );
        }),
      ),
    );
  }

  Widget _buildCategoriesTab() {
    if (controller.categories.isEmpty) {
      return _buildEmptyState(Icons.category, 'Belum ada kategori');
    }
    return RefreshIndicator(
      onRefresh: controller.loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final cat = controller.categories[index];
          return _buildCategoryCard(
            cat.name,
            '${cat.bookCount} buku',
            Icons.category_rounded,
            _getCategoryColor(index),
            () => Get.toNamed(
              Routes.LATEST_BOOK,
              arguments: {
                'filterType': 'category',
                'slug': cat.slug,
                'title': cat.name,
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookshelvesTab() {
    if (controller.bookshelves.isEmpty) {
      return _buildEmptyState(Icons.shelves, 'Belum ada rak buku');
    }
    return RefreshIndicator(
      onRefresh: controller.loadData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.bookshelves.length,
        itemBuilder: (context, index) {
          final shelf = controller.bookshelves[index];
          return _buildCategoryCard(
            shelf.name,
            '${shelf.bookCount} buku',
            Icons.shelves,
            _getShelfColor(index),
            () => Get.toNamed(
              Routes.LATEST_BOOK,
              arguments: {
                'filterType': 'bookshelf',
                'slug': shelf.slug,
                'title': shelf.name,
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(text, style: TextStyle(fontSize: 18, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Color _getCategoryColor(int index) {
    const colors = [
      Color(0xFF1E3A8A),
      Color(0xFF10B981),
      Color(0xFF8B5CF6),
      Color(0xFFEF4444),
      Color(0xFFF59E0B),
      Color(0xFF06B6D4),
      Color(0xFFEC4899),
      Color(0xFF64748B),
    ];
    return colors[index % colors.length];
  }

  Color _getShelfColor(int index) {
    const colors = [
      Color(0xFFF59E0B),
      Color(0xFF1E3A8A),
      Color(0xFF10B981),
      Color(0xFFEF4444),
      Color(0xFF8B5CF6),
      Color(0xFF06B6D4),
    ];
    return colors[index % colors.length];
  }
}
