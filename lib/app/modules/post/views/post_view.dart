import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/modules/post/views/post_detail_view.dart';

import '../controllers/post_controller.dart';

class PostView extends GetView<PostController> {
  PostView({Key? key}) : super(key: key);
  final PostController controller = Get.put(PostController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(controller.errorMessage.value),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: controller.fetchPost,
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          );
        }

        final posts = controller.posts;
        if (posts.isEmpty) {
          return const Center(child: Text('Data kosong'));
        }

        return ListView.separated(
          itemCount: posts.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (ctx, i) {
            final post = posts[i];
            return ListTile(
              leading: Image.network(
                'https://picsum.photos/id/${post.id % 1000}/64/64',
                fit: BoxFit.cover,
              ),
              title: Text(post.title),
              subtitle: Text(
                post.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => Get.to(() => PostDetailView(post: post)),
            );
          },
        );
      }),
    );
  }
}
