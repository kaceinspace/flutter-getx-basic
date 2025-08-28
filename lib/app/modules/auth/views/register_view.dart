import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rpl1getx/app/modules/auth/controllers/auth_controller.dart';

class RegisterView extends GetView {
  RegisterView({super.key});
  final AuthController c = Get.put(AuthController());

  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RegisterView'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameC,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailC,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordC,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Obx(() {
              if (c.isLoading.value) {
                return CircularProgressIndicator();
              }
              return ElevatedButton(
                onPressed: () {
                  c.register(nameC.text, emailC.text, passwordC.text);
                },
                child: Text('Register'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
