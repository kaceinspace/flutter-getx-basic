import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rpl1getx/app/modules/post/controllers/post_controller.dart';

class CreatePostView extends StatelessWidget {
  final PostController controller = Get.find();

  final TextEditingController titleC = TextEditingController();
  final TextEditingController contentC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Post")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleC,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: contentC,
              decoration: InputDecoration(labelText: "Content"),
            ),
            SizedBox(height: 10),
            Obx(
              () => controller.selectedImage.value != null
                  ? Image.file(controller.selectedImage.value!, height: 150)
                  : Text("No image selected"),
            ),
            ElevatedButton(
              onPressed: () => controller.pickImage(),
              child: Text("Pick Image"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = await controller.createPost(
                  titleC.text,
                  contentC.text,
                );
                if (success) Get.back();
              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
