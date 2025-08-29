import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/modules/post/controllers/post_controller.dart';
import 'package:rpl1getx/app/data/models/post.dart';

class EditPostView extends StatelessWidget {
  final DataPost? post;
  final PostController controller = Get.find();

  late final TextEditingController titleC;
  late final TextEditingController contentC;

  EditPostView({Key? key, this.post}) : super(key: key) {
    // Get post from arguments if not provided
    final DataPost? postData = post ?? Get.arguments as DataPost?;

    if (postData == null) {
      // Redirect to post list if no post data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offNamed('/post');
      });
    }

    titleC = TextEditingController(text: postData?.title ?? '');
    contentC = TextEditingController(text: postData?.content ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final DataPost? postData = post ?? Get.arguments as DataPost?;

    if (postData == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Edit Post',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Your Post',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Update your post details below',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // Title Field
                TextField(
                  controller: titleC,
                  decoration: InputDecoration(
                    labelText: "Post Title",
                    hintText: "Enter your post title",
                    prefixIcon: const Icon(
                      Icons.title,
                      color: Color(0xFF6C5CE7),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF6C5CE7),
                        width: 2,
                      ),
                    ),
                    fillColor: Colors.grey[50],
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16),

                // Content Field
                TextField(
                  controller: contentC,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Post Content",
                    hintText: "Write your post content here...",
                    prefixIcon: const Icon(
                      Icons.article,
                      color: Color(0xFF6C5CE7),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF6C5CE7),
                        width: 2,
                      ),
                    ),
                    fillColor: Colors.grey[50],
                    filled: true,
                  ),
                ),
                const SizedBox(height: 20),

                // Current Image
                if (postData.foto != null && postData.foto!.isNotEmpty) ...[
                  const Text(
                    'Current Image:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        'http://127.0.0.1:8000/storage/${postData.foto}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // New Image Selection
                const Text(
                  'Update Image (Optional):',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 8),

                Obx(() {
                  if (kIsWeb) {
                    if (controller.selectedImageBytes.value != null) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF6C5CE7)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            controller.selectedImageBytes.value!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                  } else {
                    if (controller.selectedImage.value != null) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF6C5CE7)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            controller.selectedImage.value!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                  }
                  return Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "No new image selected",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 12),

                // Pick Image Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => controller.pickImage(),
                    icon: const Icon(
                      Icons.photo_library,
                      color: Color(0xFF6C5CE7),
                    ),
                    label: const Text(
                      "Choose New Image",
                      style: TextStyle(
                        color: Color(0xFF6C5CE7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF6C5CE7)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                // Clear Image Button (jika ada gambar baru)
                Obx(() {
                  if ((kIsWeb && controller.selectedImageBytes.value != null) ||
                      (!kIsWeb && controller.selectedImage.value != null)) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SizedBox(
                        width: double.infinity,
                        height: 40,
                        child: TextButton.icon(
                          onPressed: () => controller.clearSelectedImage(),
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.red,
                            size: 18,
                          ),
                          label: const Text(
                            "Remove New Image",
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              controller.clearSelectedImage();
                              Get.back();
                            },
                            child: const Center(
                              child: Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () async {
                              if (titleC.text.isEmpty ||
                                  contentC.text.isEmpty) {
                                Get.snackbar(
                                  "Error",
                                  "Please fill in title and content",
                                  backgroundColor: Colors.red.withOpacity(0.1),
                                  colorText: Colors.red,
                                );
                                return;
                              }

                              // Show loading
                              Get.dialog(
                                const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF6C5CE7),
                                    ),
                                  ),
                                ),
                                barrierDismissible: false,
                              );

                              bool success = await controller.updatePost(
                                postData.id!,
                                titleC.text,
                                contentC.text,
                              );

                              // Close loading dialog
                              Get.back();
                            },
                            child: const Center(
                              child: Text(
                                "Update Post",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
