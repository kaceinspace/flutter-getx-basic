import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/data/models/book_model.dart';
import 'package:rpl1getx/app/utils/api.dart';
import '../controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1E3A8A)),
                );
              }

              // Show books for selected category
              if (controller.selectedCategory.value != null) {
                return _buildCategoryBooks();
              }

              // Show category grid
              return _buildCategoryGrid();
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
        left: 8,
        right: 24,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (controller.selectedCategory.value != null) {
                controller.clearSelection();
              } else {
                Get.back();
              }
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF1E3A8A),
              size: 24,
            ),
          ),
          Expanded(
            child: Obx(
              () => Text(
                controller.selectedCategory.value?.name.toUpperCase() ??
                    'KATEGORI',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E3A8A),
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 1.4,
      ),
      itemCount: controller.categories.length,
      itemBuilder: (_, i) => _buildCategoryCard(controller.categories[i], i),
    );
  }

  Widget _buildCategoryCard(CategoryModel category, int index) {
    // Cycle through colors
    final colors = [
      [const Color(0xFF1E3A8A), const Color(0xFF2563EB)],
      [const Color(0xFF7C3AED), const Color(0xFF8B5CF6)],
      [const Color(0xFFD97706), const Color(0xFFF59E0B)],
      [const Color(0xFF059669), const Color(0xFF10B981)],
      [const Color(0xFFDC2626), const Color(0xFFEF4444)],
      [const Color(0xFF0891B2), const Color(0xFF06B6D4)],
    ];
    final colorPair = colors[index % colors.length];

    final icons = [
      Icons.auto_stories_rounded,
      Icons.science_rounded,
      Icons.palette_rounded,
      Icons.mosque_rounded,
      Icons.history_edu_rounded,
      Icons.psychology_rounded,
      Icons.biotech_rounded,
      Icons.calculate_rounded,
    ];
    final icon = icons[index % icons.length];

    return GestureDetector(
      onTap: () => controller.selectCategory(category),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colorPair,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: colorPair[0].withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: Colors.white),
            ),
            // Name + count
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                if (category.bookCount != null)
                  Text(
                    '${category.bookCount} buku',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBooks() {
    return Obx(() {
      if (controller.isLoadingBooks.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF1E3A8A)),
        );
      }

      if (controller.booksForCategory.isEmpty) {
        return Center(
          child: Opacity(
            opacity: 0.3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.menu_book_rounded, size: 48),
                SizedBox(height: 12),
                Text(
                  'BELUM ADA BUKU',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 24,
          childAspectRatio: 0.52,
        ),
        itemCount: controller.booksForCategory.length,
        itemBuilder: (_, i) => _buildBookCard(controller.booksForCategory[i]),
      );
    });
  }

  Widget _buildBookCard(BookModel book) {
    final coverUrl = book.cover != null && book.cover!.isNotEmpty
        ? '${BaseUrl.storageUrl}/${book.cover}'
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: coverUrl != null
                      ? Image.network(
                          coverUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildCoverPlaceholder(),
                        )
                      : _buildCoverPlaceholder(),
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A).withOpacity(0.8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
              if (book.quantity != null)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inventory_2_rounded,
                          size: 10,
                          color: book.quantity! > 0
                              ? const Color(0xFF16A34A)
                              : Colors.red,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${book.quantity}',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: book.quantity! > 0
                                ? const Color(0xFF1E3A8A)
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (book.category != null)
                Text(
                  book.category!.name.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2563EB),
                    letterSpacing: 1.2,
                  ),
                ),
              const SizedBox(height: 3),
              Text(
                book.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E3A8A),
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                book.author?.name ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCoverPlaceholder() {
    return Container(
      color: const Color(0xFFE2E8F0),
      child: const Center(
        child: Icon(
          Icons.menu_book_rounded,
          color: Color(0xFF94A3B8),
          size: 36,
        ),
      ),
    );
  }
}
