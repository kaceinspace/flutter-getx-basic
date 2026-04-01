import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/data/models/content_model.dart';
import '../controllers/content_controller.dart';

class ContentView extends GetView<ContentController> {
  const ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: controller.tabIndex.value,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: AppBar(
          title: const Text(
            'Konten Digital',
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
              Tab(icon: Icon(Icons.picture_as_pdf), text: 'PDF'),
              Tab(icon: Icon(Icons.play_circle_outline), text: 'Video'),
            ],
          ),
        ),
        body: TabBarView(children: [_buildPdfTab(), _buildVideoTab()]),
      ),
    );
  }

  Widget _buildPdfTab() {
    return Obx(() {
      if (controller.isLoadingPdfs.value && controller.pdfs.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.pdfs.isEmpty) {
        return _buildEmptyState(Icons.picture_as_pdf, 'Belum ada PDF');
      }
      return RefreshIndicator(
        onRefresh: () => controller.loadPdfs(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.pdfs.length + (controller.hasMorePdfs ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.pdfs.length) {
              return _buildLoadMoreButton(controller.loadMorePdfs);
            }
            return _buildContentCard(controller.pdfs[index], isPdf: true);
          },
        ),
      );
    });
  }

  Widget _buildVideoTab() {
    return Obx(() {
      if (controller.isLoadingVideos.value && controller.videos.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.videos.isEmpty) {
        return _buildEmptyState(Icons.play_circle_outline, 'Belum ada Video');
      }
      return RefreshIndicator(
        onRefresh: () => controller.loadVideos(),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount:
              controller.videos.length + (controller.hasMoreVideos ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.videos.length) {
              return _buildLoadMoreButton(controller.loadMoreVideos);
            }
            return _buildContentCard(controller.videos[index], isPdf: false);
          },
        ),
      );
    });
  }

  Widget _buildContentCard(ContentData content, {required bool isPdf}) {
    return GestureDetector(
      onTap: () => _showContentDetail(content, isPdf),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
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
              width: 60,
              height: 70,
              decoration: BoxDecoration(
                color: (isPdf ? Colors.red : Colors.blue).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: content.fullCoverUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        content.fullCoverUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          isPdf ? Icons.picture_as_pdf : Icons.play_circle,
                          color: isPdf ? Colors.red : Colors.blue,
                          size: 30,
                        ),
                      ),
                    )
                  : Icon(
                      isPdf ? Icons.picture_as_pdf : Icons.play_circle,
                      color: isPdf ? Colors.red : Colors.blue,
                      size: 30,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    content.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (content.contentCategory != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A8A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        content.contentCategory!.name,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    content.desc,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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

  void _showContentDetail(ContentData content, bool isPdf) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (content.fullCoverUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    content.fullCoverUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                content.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                ),
              ),
              const SizedBox(height: 8),
              if (content.contentCategory != null)
                Chip(
                  label: Text(content.contentCategory!.name),
                  backgroundColor: const Color(0xFF1E3A8A).withOpacity(0.1),
                ),
              const SizedBox(height: 12),
              Text(
                content.desc,
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    Get.snackbar(
                      'Info',
                      isPdf ? 'Membuka PDF...' : 'Memutar Video...',
                      backgroundColor: const Color(0xFF1E3A8A),
                      colorText: Colors.white,
                    );
                  },
                  icon: Icon(
                    isPdf ? Icons.open_in_new : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  label: Text(
                    isPdf ? 'Buka PDF' : 'Putar Video',
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
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
      ),
      isScrollControlled: true,
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

  Widget _buildLoadMoreButton(VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E3A8A),
          ),
          child: const Text(
            'Muat Lebih Banyak',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
