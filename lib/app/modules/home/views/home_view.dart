import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/data/models/book_model.dart';
import 'package:rpl1getx/app/data/models/content_model.dart';
import 'package:rpl1getx/app/utils/api.dart';
import 'package:rpl1getx/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          _buildTopSection(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value &&
                  controller.books.isEmpty &&
                  controller.videos.isEmpty &&
                  controller.pdfs.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1E3A8A)),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshData,
                color: const Color(0xFF1E3A8A),
                child: _buildScrollableContent(),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(Get.context!).padding.top + 12,
              left: 24,
              right: 24,
              bottom: 12,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LIBRARY ELSA',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E3A8A),
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller.searchController,
                onSubmitted: controller.searchBooks,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E3A8A),
                ),
                decoration: InputDecoration(
                  hintText: 'Cari buku, penulis...',
                  hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Colors.grey.shade400,
                    size: 22,
                  ),
                  suffixIcon: Obx(
                    () => controller.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.close_rounded,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                            onPressed: () {
                              controller.searchController.clear();
                              controller.searchBooks('');
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Category chips
          _buildCategoryChips(),

          const SizedBox(height: 8),
          Container(height: 1, color: const Color(0xFFF1F5F9)),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 36,
      child: Obx(() {
        // Limit to 5 categories + "Semua" + "Lainnya" button
        final limitedCategories = controller.categories.take(5).toList();

        return ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            // "Semua" chip
            _buildChip('Semua', controller.activeCategory.value == 'Semua'),
            const SizedBox(width: 8),

            // Category chips
            ...limitedCategories.map((c) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildChip(
                  c.name,
                  controller.activeCategory.value == c.name,
                ),
              );
            }),

            // "Lainnya >" button to category page
            if (controller.categories.length > 5)
              GestureDetector(
                onTap: () => Get.toNamed(Routes.CATEGORY),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFACC15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'LAINNYA',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E3A8A),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 12,
                        color: Color(0xFF1E3A8A),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildChip(String name, bool isActive) {
    return GestureDetector(
      onTap: () => controller.selectCategory(name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1E3A8A) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? const Color(0xFF1E3A8A) : const Color(0xFFF1F5F9),
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF1E3A8A).withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          name.toUpperCase(),
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w900,
            color: isActive ? Colors.white : const Color(0xFF94A3B8),
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableContent() {
    return Obx(() {
      final hasBooks = controller.books.isNotEmpty;
      final hasVideos = controller.videos.isNotEmpty;
      final hasPdfs = controller.pdfs.isNotEmpty;

      if (!hasBooks && !hasVideos && !hasPdfs) {
        return _buildEmptyState();
      }

      return ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          // --- BUKU SECTION ---
          if (hasBooks) ...[
            _buildSectionHeader(
              icon: Icons.menu_book_rounded,
              title: 'Koleksi Buku',
              count: controller.books.length,
            ),
            _buildBooksGrid(),
          ],

          // --- VIDEO SECTION ---
          if (hasVideos) ...[
            _buildSectionHeader(
              icon: Icons.play_circle_rounded,
              title: 'Koleksi Video',
              count: controller.videos.length,
            ),
            _buildContentList(controller.videos, isVideo: true),
          ],

          // --- PDF SECTION ---
          if (hasPdfs) ...[
            _buildSectionHeader(
              icon: Icons.picture_as_pdf_rounded,
              title: 'Koleksi PDF',
              count: controller.pdfs.length,
            ),
            _buildContentList(controller.pdfs, isVideo: false),
          ],
        ],
      );
    });
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required int count,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF1E3A8A)),
          ),
          const SizedBox(width: 10),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E3A8A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: Color(0xFF2563EB),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Obx(
        () => GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
            childAspectRatio: 0.52,
          ),
          itemCount: controller.books.length,
          itemBuilder: (_, i) => _buildBookCard(controller.books[i]),
        ),
      ),
    );
  }

  // --- Content horizontal list (Video / PDF) ---
  Widget _buildContentList(List<ContentModel> items, {required bool isVideo}) {
    return SizedBox(
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => _buildContentCard(items[i], isVideo: isVideo),
      ),
    );
  }

  Widget _buildContentCard(ContentModel item, {required bool isVideo}) {
    final coverUrl = item.cover != null && item.cover!.isNotEmpty
        ? '${BaseUrl.storageUrl}/${item.cover}'
        : null;

    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
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
                    borderRadius: BorderRadius.circular(22),
                    child: coverUrl != null
                        ? Image.network(
                            coverUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildContentCoverPlaceholder(isVideo),
                          )
                        : _buildContentCoverPlaceholder(isVideo),
                  ),
                ),

                // Type badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A).withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isVideo
                          ? Icons.play_circle_rounded
                          : Icons.picture_as_pdf_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Open button
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'BUKA',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E3A8A),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(
                          Icons.open_in_new_rounded,
                          size: 11,
                          color: Color(0xFF1E3A8A),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (item.contentCategory != null) ...[
                      Flexible(
                        child: Text(
                          item.contentCategory!.name.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2563EB),
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 3,
                        height: 3,
                        decoration: const BoxDecoration(
                          color: Color(0xFFCBD5E1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                    Text(
                      isVideo ? 'VIDEO' : 'PDF',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E3A8A),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentCoverPlaceholder(bool isVideo) {
    return Container(
      color: isVideo ? const Color(0xFFEDE9FE) : const Color(0xFFFEF3C7),
      child: Center(
        child: Icon(
          isVideo ? Icons.play_circle_rounded : Icons.picture_as_pdf_rounded,
          size: 36,
          color: isVideo ? const Color(0xFF7C3AED) : const Color(0xFFD97706),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        const SizedBox(height: 100),
        Center(
          child: Opacity(
            opacity: 0.3,
            child: Column(
              children: const [
                Icon(Icons.layers_rounded, size: 48),
                SizedBox(height: 12),
                Text(
                  'TIDAK ADA KOLEKSI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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

              // Type badge
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

              // Stock badge
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

              // Add to cart
              if (book.quantity != null && book.quantity! > 0)
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => controller.addToCart(book),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFACC15),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFACC15).withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        size: 18,
                        color: Color(0xFF1E3A8A),
                      ),
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
              Row(
                children: [
                  if (book.category != null) ...[
                    Text(
                      book.category!.name.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2563EB),
                        letterSpacing: 1.2,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: Color(0xFFCBD5E1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                  Text(
                    'BUKU',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
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
