import 'package:flutter/material.dart';

import 'package:get/get.dart';

class EditPostView extends GetView {
  const EditPostView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PostEditView'), centerTitle: true),
      body: const Center(
        child: Text('PostEditView is working', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
