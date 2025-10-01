import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/data/models/dashboard.dart';
import 'package:rpl1getx/app/modules/profile/controllers/profile_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController pController = Get.put(ProfileController());
    final DashboardController controller = Get.put(DashboardController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFF60A5FA)],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: controller.refreshDashboard,
            color: const Color(0xFF1E3A8A),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildHeader(pController),
                    const SizedBox(height: 20),
                    // Stats Cards
                    _buildStatsSection(),
                    const SizedBox(height: 20),
                    // Quick Actions
                    _buildQuickActions(),
                    const SizedBox(height: 20),
                    // Latest Books Section
                    _buildLatestBooksSection(),
                    const SizedBox(height: 20),
                    // Digital Collection Section
                    _buildDigitalCollectionSection(),
                    const SizedBox(height: 20),
                    // My Activities Section
                    _buildActivitiesSection(pController),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ProfileController pController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang!',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Obx(() {
                    final user = pController.userProfile.value;
                    return Text(
                      user['name']?.toString() ?? 'Pengguna',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    );
                  }),
                ],
              ),
            ),
            Row(
              children: [
                // Refresh button
                Obx(
                  () => GestureDetector(
                    onTap: controller.isLoading.value
                        ? null
                        : controller.refreshDashboard,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(
                              Icons.refresh_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Notification button
                GestureDetector(
                  onTap: () {
                    Get.snackbar(
                      'Notifikasi',
                      'Belum ada notifikasi baru',
                      backgroundColor: const Color(0xFF1E3A8A),
                      colorText: Colors.white,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.notifications_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFBBF24).withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFBBF24).withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.school_rounded,
                color: Color(0xFFFBBF24),
                size: 16,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Obx(() {
                  final user = pController.userProfile.value;
                  return Text(
                    'SMK ASSALAAM BANDUNG - ${user['jurusan']?.toString() ?? 'Perpustakaan Digital'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Obx(() {
      if (controller.isLoadingSummary.value) {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }

      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Buku',
              controller.totalBooks.toString(),
              Icons.library_books_rounded,
              const Color(0xFF10B981),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'Dipinjam',
              controller.borrowedBooks.toString(),
              Icons.bookmark_rounded,
              const Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              'E-Books',
              controller.totalEbooks.toString(),
              Icons.tablet_mac_rounded,
              const Color(0xFF8B5CF6),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              count,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Aksi Cepat',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionItem(
                  'Cari Buku',
                  Icons.search_rounded,
                  const Color(0xFF1E3A8A),
                  () {
                    Get.snackbar(
                      'Coming Soon',
                      'Fitur pencarian buku akan segera tersedia!',
                      backgroundColor: const Color(0xFF1E3A8A),
                      colorText: Colors.white,
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickActionItem(
                  'Keranjang',
                  Icons.shopping_cart_rounded,
                  const Color(0xFFF59E0B),
                  () {
                    Get.snackbar(
                      'Coming Soon',
                      'Fitur keranjang akan segera tersedia!',
                      backgroundColor: const Color(0xFFF59E0B),
                      colorText: Colors.white,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionItem(
                  'Pinjaman',
                  Icons.bookmark_rounded,
                  const Color(0xFF10B981),
                  () {
                    Get.snackbar(
                      'Coming Soon',
                      'Fitur pinjaman akan segera tersedia!',
                      backgroundColor: const Color(0xFF10B981),
                      colorText: Colors.white,
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickActionItem(
                  'Digital',
                  Icons.tablet_mac_rounded,
                  const Color(0xFF8B5CF6),
                  () {
                    Get.snackbar(
                      'Coming Soon',
                      'Koleksi digital akan segera tersedia!',
                      backgroundColor: const Color(0xFF8B5CF6),
                      colorText: Colors.white,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestBooksSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Buku Terbaru',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.snackbar(
                    'Coming Soon',
                    'Daftar lengkap buku akan segera tersedia!',
                    backgroundColor: const Color(0xFFFBBF24),
                    colorText: Colors.black,
                  );
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: Color(0xFFFBBF24),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: Obx(() {
              if (controller.isLoadingBooks.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF1E3A8A)),
                );
              }

              if (controller.latestBooks.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada buku terbaru',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.latestBooks.length,
                itemBuilder: (context, index) {
                  final book = controller.latestBooks[index];
                  return _buildBookCard(book);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(LatestBook book) {
    return GestureDetector(
      // onTap: () => controller.showBookDetail(book),
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A).withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Center(
                child: book.cover != null && book.cover!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Image.network(
                          book.cover,
                          width: 100,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.book_rounded,
                              color: Color(0xFF1E3A8A),
                              size: 28,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.book_rounded,
                        color: Color(0xFF1E3A8A),
                        size: 28,
                      ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title ?? 'Unknown Title',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E3A8A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      book.author ?? 'Unknown Author',
                      style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (book.stock != null && book.stock > 0)
                            ? const Color(0xFF10B981).withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        (book.stock != null && book.stock > 0)
                            ? 'Tersedia'
                            : 'Habis',
                        style: TextStyle(
                          fontSize: 8,
                          color: (book.stock != null && book.stock > 0)
                              ? const Color(0xFF10B981)
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitalCollectionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Koleksi Digital',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.snackbar(
                    'Coming Soon',
                    'Koleksi digital akan segera tersedia!',
                    backgroundColor: const Color(0xFFFBBF24),
                    colorText: Colors.black,
                  );
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: Color(0xFFFBBF24),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDigitalItem(
                  'E-Books',
                  controller.totalEbooks.toString(),
                  Icons.tablet_mac_rounded,
                  const Color(0xFF8B5CF6),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDigitalItem(
                  'Video',
                  controller.totalVideos.toString(),
                  Icons.play_circle_rounded,
                  const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildDigitalItem(
                  'Audio',
                  '89',
                  Icons.headphones_rounded,
                  const Color(0xFF06B6D4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDigitalItem(
    String title,
    String count,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Get.snackbar(
          'Coming Soon',
          '$title akan segera tersedia!',
          backgroundColor: color,
          colorText: Colors.white,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(count, style: TextStyle(fontSize: 9, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitiesSection(ProfileController pController) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Aktivitas Saya',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.snackbar(
                    'Coming Soon',
                    'History aktivitas akan segera tersedia!',
                    backgroundColor: const Color(0xFFFBBF24),
                    colorText: Colors.black,
                  );
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: Color(0xFFFBBF24),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            final user = pController.userProfile.value;
            if (pController.isLoading.value) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: CircularProgressIndicator(color: Color(0xFF1E3A8A)),
                ),
              );
            }

            if (user.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Belum ada aktivitas',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            }

            return Column(
              children: [
                _buildActivityItem(
                  'Buku Pemrograman ${user['jurusan'] ?? 'Mobile'}',
                  'Dipinjam 2 hari yang lalu - NIS: ${user['nis'] ?? ''}',
                  Icons.bookmark_rounded,
                  const Color(0xFF10B981),
                  'Aktif',
                ),
                const SizedBox(height: 8),
                _buildActivityItem(
                  'Matematika Diskrit',
                  'Dikembalikan 1 minggu lalu',
                  Icons.check_circle_rounded,
                  Colors.grey,
                  'Selesai',
                ),
                const SizedBox(height: 8),
                _buildActivityItem(
                  'E-Book: Algoritma ${user['jurusan'] ?? 'Data'}',
                  'Dibaca 3 hari yang lalu',
                  Icons.tablet_mac_rounded,
                  const Color(0xFF8B5CF6),
                  'Digital',
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    String status,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E3A8A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 9,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
