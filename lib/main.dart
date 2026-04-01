import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(
    GetMaterialApp(
      title: "Perpustakaan Digital",
      home: const Scaffold(body: Center(child: Text('Ready'))),
      debugShowCheckedModeBanner: false,
    ),
  );
}
