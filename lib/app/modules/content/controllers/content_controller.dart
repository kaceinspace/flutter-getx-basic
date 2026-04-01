import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/data/models/content_model.dart';
import 'package:rpl1getx/app/services/content_service.dart';

class ContentController extends GetxController {
  final ContentService _contentService = Get.put(ContentService());

  // PDFs
  RxList<ContentData> pdfs = <ContentData>[].obs;
  RxBool isLoadingPdfs = false.obs;
  RxInt pdfPage = 1.obs;
  RxInt pdfLastPage = 1.obs;

  // Videos
  RxList<ContentData> videos = <ContentData>[].obs;
  RxBool isLoadingVideos = false.obs;
  RxInt videoPage = 1.obs;
  RxInt videoLastPage = 1.obs;

  // Tab index
  RxInt tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final type = Get.arguments as String?;
    if (type == 'video') tabIndex.value = 1;
    loadPdfs();
    loadVideos();
  }

  Future<void> loadPdfs({int page = 1}) async {
    try {
      isLoadingPdfs(true);
      final response = await _contentService.getPdfs(page: page);
      if (response.statusCode == 200 && response.body != null) {
        final parsed = ContentList.fromJson(response.body);
        if (parsed.data != null) {
          if (page == 1) {
            pdfs.assignAll(parsed.data!.data);
          } else {
            pdfs.addAll(parsed.data!.data);
          }
          pdfPage.value = parsed.data!.currentPage;
          pdfLastPage.value = parsed.data!.lastPage;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat PDF',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingPdfs(false);
    }
  }

  Future<void> loadVideos({int page = 1}) async {
    try {
      isLoadingVideos(true);
      final response = await _contentService.getVideos(page: page);
      if (response.statusCode == 200 && response.body != null) {
        final parsed = ContentList.fromJson(response.body);
        if (parsed.data != null) {
          if (page == 1) {
            videos.assignAll(parsed.data!.data);
          } else {
            videos.addAll(parsed.data!.data);
          }
          videoPage.value = parsed.data!.currentPage;
          videoLastPage.value = parsed.data!.lastPage;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat Video',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingVideos(false);
    }
  }

  void loadMorePdfs() {
    if (pdfPage.value < pdfLastPage.value) {
      loadPdfs(page: pdfPage.value + 1);
    }
  }

  void loadMoreVideos() {
    if (videoPage.value < videoLastPage.value) {
      loadVideos(page: videoPage.value + 1);
    }
  }

  bool get hasMorePdfs => pdfPage.value < pdfLastPage.value;
  bool get hasMoreVideos => videoPage.value < videoLastPage.value;
}
