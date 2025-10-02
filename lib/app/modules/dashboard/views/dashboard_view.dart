import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/data/models/latests_book.dart';
import 'package:rpl1getx/app/modules/profile/controllers/profile_controller.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController pController = Get.put(ProfileController());
    final DashboardController dController = Get.put(DashboardController());

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
            onRefresh: dController.refreshDashboard,
            color: const Color(0xFF1E3A8A),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildHeader(pController, dController),
                    const SizedBox(height: 20),

                    // Search Section
                    _buildSearchSection(),
                    const SizedBox(height: 20),

                    // Stats Cards
                    _buildStatsSection(dController),
                    const SizedBox(height: 20),

                    // Menu Grid - Updated with all requested menus
                    _buildMenuGrid(),
                    const SizedBox(height: 20),

                    // Latest Books Section
                    _buildLatestBooksSection(dController),
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

  Widget _buildHeader(
    ProfileController pController,
    DashboardController dController,
  ) {
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
                    'Perpustakaan Digital',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Obx(() {
                    final user = pController.userProfile.value;
                    return Text(
                      user['name']?.toString() ?? 'SMK ASSALAAM BANDUNG',
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
                _buildHeaderIcon(
                  Icons.refresh_rounded,
                  () => dController.refreshDashboard(),
                ),
                const SizedBox(width: 8),
                // Notification button
                _buildHeaderIcon(
                  Icons.notifications_rounded,
                  () => Get.snackbar(
                    'Notifikasi',
                    'Belum ada notifikasi baru',
                    backgroundColor: const Color(0xFF1E3A8A),
                    colorText: Colors.white,
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
              const Expanded(
                child: Text(
                  'Sistem Perpustakaan Digital - Akses Mudah, Belajar Cerdas',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildSearchSection() {
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
            children: [
              const Icon(
                Icons.search_rounded,
                color: Color(0xFF1E3A8A),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Pencarian Cepat',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari buku, penulis, kategori, atau ISBN...',
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF1E3A8A),
                ),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  _showSearchResults(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(DashboardController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Buku',
            '2,456',
            Icons.library_books_rounded,
            const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            'E-Books',
            '842',
            Icons.tablet_mac_rounded,
            const Color(0xFF8B5CF6),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildStatCard(
            'Video',
            '156',
            Icons.play_circle_rounded,
            const Color(0xFFEF4444),
          ),
        ),
      ],
    );
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

  Widget _buildMenuGrid() {
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
            children: [
              const Icon(
                Icons.dashboard_rounded,
                color: Color(0xFF1E3A8A),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Menu Perpustakaan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // First Row - Main Features
          Row(
            children: [
              Expanded(
                child: _buildMenuCard(
                  'Latest Buku',
                  'Buku terbaru dari koleksi',
                  Icons.new_releases_rounded,
                  const Color(0xFF10B981),
                  () => _showMenuDetail('Latest Buku'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMenuCard(
                  'Semua Buku',
                  'Katalog lengkap perpustakaan',
                  Icons.library_books_rounded,
                  const Color(0xFF1E3A8A),
                  () => _showMenuDetail('Semua Buku'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Second Row - Organization
          Row(
            children: [
              Expanded(
                child: _buildMenuCard(
                  'Rak Buku',
                  'Lokasi dan penempatan buku',
                  Icons.shelves,
                  const Color(0xFFF59E0B),
                  () => _showMenuDetail('Rak Buku'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMenuCard(
                  'Kategori',
                  'Klasifikasi buku berdasarkan topik',
                  Icons.category_rounded,
                  const Color(0xFF8B5CF6),
                  () => _showMenuDetail('Kategori'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Third Row - Digital Content
          Row(
            children: [
              Expanded(
                child: _buildMenuCard(
                  'PDF Digital',
                  'Koleksi e-book format PDF',
                  Icons.picture_as_pdf_rounded,
                  const Color(0xFFEF4444),
                  () => _showMenuDetail('PDF Digital'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMenuCard(
                  'Video Learning',
                  'Video pembelajaran interaktif',
                  Icons.play_circle_rounded,
                  const Color(0xFF06B6D4),
                  () => _showMenuDetail('Video Learning'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Fourth Row - Search & Favorites
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildMenuCardLarge(
                  'Pencarian Lanjutan',
                  'Cari dengan filter kategori, penulis, tahun terbit, dan lokasi rak',
                  Icons.manage_search_rounded,
                  const Color(0xFF1E3A8A),
                  () => _showAdvancedSearch(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMenuCard(
                  'Favorit',
                  'Buku yang disimpan',
                  Icons.favorite_rounded,
                  const Color(0xFFEC4899),
                  () => _showMenuDetail('Favorit'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Fifth Row - Additional Features
          Row(
            children: [
              Expanded(
                child: _buildMenuCard(
                  'Riwayat',
                  'History peminjaman',
                  Icons.history_rounded,
                  const Color(0xFF64748B),
                  () => _showMenuDetail('Riwayat'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMenuCard(
                  'Pinjaman',
                  'Buku yang sedang dipinjam',
                  Icons.bookmark_rounded,
                  const Color(0xFF059669),
                  () => _showMenuDetail('Pinjaman'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMenuCard(
                  'Reservasi',
                  'Booking buku untuk dipinjam',
                  Icons.event_available_rounded,
                  const Color(0xFFD97706),
                  () => _showMenuDetail('Reservasi'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 9, color: color.withOpacity(0.8)),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCardLarge(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatestBooksSection(DashboardController controller) {
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
              Row(
                children: [
                  const Icon(
                    Icons.auto_stories_rounded,
                    color: Color(0xFF1E3A8A),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Buku Terbaru',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => _showMenuDetail('Semua Buku Terbaru'),
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
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8, // Static count for UI demo
              itemBuilder: (context, index) {
                return _buildDemoBookCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoBookCard(int index) {
    final List<Map<String, dynamic>> demoBooks = [
      {
        'title': 'Flutter Development',
        'author': 'Google Developers',
        'category': 'Programming',
        'color': const Color(0xFF1E3A8A),
        'available': true,
      },
      {
        'title': 'Database Management',
        'author': 'MySQL Team',
        'category': 'Database',
        'color': const Color(0xFF10B981),
        'available': true,
      },
      {
        'title': 'Network Security',
        'author': 'Cisco Academy',
        'category': 'Network',
        'color': const Color(0xFFEF4444),
        'available': false,
      },
      {
        'title': 'UI/UX Design',
        'author': 'Adobe Team',
        'category': 'Design',
        'color': const Color(0xFF8B5CF6),
        'available': true,
      },
      {
        'title': 'Machine Learning',
        'author': 'TensorFlow',
        'category': 'AI',
        'color': const Color(0xFFF59E0B),
        'available': true,
      },
      {
        'title': 'Cloud Computing',
        'author': 'AWS Team',
        'category': 'Cloud',
        'color': const Color(0xFF06B6D4),
        'available': true,
      },
      {
        'title': 'Cyber Security',
        'author': 'Security Experts',
        'category': 'Security',
        'color': const Color(0xFFDC2626),
        'available': false,
      },
      {
        'title': 'Data Science',
        'author': 'Python Foundation',
        'category': 'Data',
        'color': const Color(0xFF059669),
        'available': true,
      },
    ];

    final book = demoBooks[index];

    return GestureDetector(
      onTap: () => _showDemoBookDetail(book),
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
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
            // Book cover simulation
            Container(
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [book['color'], book['color'].withOpacity(0.7)],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(Icons.book_rounded, color: Colors.white, size: 32),
              ),
            ),
            // Book info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book['title'],
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E3A8A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book['author'],
                      style: TextStyle(fontSize: 9, color: Colors.grey[600]),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: book['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        book['category'],
                        style: TextStyle(
                          fontSize: 8,
                          color: book['color'],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: book['available']
                            ? const Color(0xFF10B981).withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        book['available'] ? 'Tersedia' : 'Dipinjam',
                        style: TextStyle(
                          fontSize: 8,
                          color: book['available']
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

  void _showMenuDetail(String menuName) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Icon(
              _getMenuIcon(menuName),
              color: const Color(0xFF1E3A8A),
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              menuName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Menu $menuName akan segera tersedia dengan fitur lengkap!',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E3A8A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Mengerti',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMenuIcon(String menuName) {
    switch (menuName) {
      case 'Latest Buku':
        return Icons.new_releases_rounded;
      case 'Semua Buku':
        return Icons.library_books_rounded;
      case 'Rak Buku':
        return Icons.shelves;
      case 'Kategori':
        return Icons.category_rounded;
      case 'PDF Digital':
        return Icons.picture_as_pdf_rounded;
      case 'Video Learning':
        return Icons.play_circle_rounded;
      case 'Favorit':
        return Icons.favorite_rounded;
      case 'Riwayat':
        return Icons.history_rounded;
      case 'Pinjaman':
        return Icons.bookmark_rounded;
      case 'Reservasi':
        return Icons.event_available_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  void _showSearchResults(String query) {
    Get.snackbar(
      'Pencarian',
      'Mencari: "$query" - Fitur pencarian akan segera tersedia!',
      backgroundColor: const Color(0xFF1E3A8A),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.search_rounded, color: Colors.white),
    );
  }

  void _showAdvancedSearch() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.manage_search_rounded,
                    color: Color(0xFF1E3A8A),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Pencarian Lanjutan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Search field
              TextField(
                decoration: InputDecoration(
                  labelText: 'Kata Kunci',
                  hintText: 'Judul buku, penulis, atau ISBN...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  prefixIcon: const Icon(Icons.category_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('Semua Kategori')),
                  DropdownMenuItem(
                    value: 'programming',
                    child: Text('Pemrograman'),
                  ),
                  DropdownMenuItem(value: 'database', child: Text('Database')),
                  DropdownMenuItem(value: 'network', child: Text('Jaringan')),
                  DropdownMenuItem(value: 'design', child: Text('Desain')),
                  DropdownMenuItem(
                    value: 'ai',
                    child: Text('Artificial Intelligence'),
                  ),
                  DropdownMenuItem(value: 'security', child: Text('Keamanan')),
                ],
                onChanged: (value) {},
                value: 'all',
              ),
              const SizedBox(height: 16),

              // Bookshelf dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Rak Buku',
                  prefixIcon: const Icon(Icons.shelves),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('Semua Rak')),
                  DropdownMenuItem(
                    value: 'a1',
                    child: Text('Rak A1 - Komputer'),
                  ),
                  DropdownMenuItem(
                    value: 'a2',
                    child: Text('Rak A2 - Jaringan'),
                  ),
                  DropdownMenuItem(
                    value: 'b1',
                    child: Text('Rak B1 - Multimedia'),
                  ),
                  DropdownMenuItem(value: 'b2', child: Text('Rak B2 - Desain')),
                  DropdownMenuItem(value: 'c1', child: Text('Rak C1 - Bisnis')),
                ],
                onChanged: (value) {},
                value: 'all',
              ),
              const SizedBox(height: 16),

              // Availability filter
              Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      title: const Text(
                        'Hanya yang tersedia',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: true,
                      onChanged: (value) {},
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        _showSearchResults('Pencarian Lanjutan');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cari Sekarang'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDemoBookDetail(Map<String, dynamic> book) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Detail Buku',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [book['color'], book['color'].withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.book_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book['title'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text('Penulis: ${book['author']}'),
                        const SizedBox(height: 4),
                        Text('Kategori: ${book['category']}'),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: book['available']
                                ? const Color(0xFF10B981).withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            book['available'] ? 'Tersedia' : 'Sedang Dipinjam',
                            style: TextStyle(
                              color: book['available']
                                  ? const Color(0xFF10B981)
                                  : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Tutup'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: book['available']
                          ? () {
                              Get.back();
                              _showMenuDetail('Peminjaman');
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E3A8A),
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        book['available'] ? 'Pinjam' : 'Tidak Tersedia',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
