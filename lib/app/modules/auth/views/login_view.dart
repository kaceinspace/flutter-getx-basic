import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rpl1getx/app/modules/auth/controllers/auth_controller.dart';

class LoginView extends GetView {
  LoginView({super.key});
  final AuthController c = Get.put(AuthController());

  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('LoginView'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
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
                  c.login(emailC.text, passwordC.text);
                },
                child: Text('Login'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
