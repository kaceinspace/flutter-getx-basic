import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CounterController extends GetxController {
  RxInt hitung = 0.obs;
  RxString nama = "RPL 1".obs;

  void increment() {
    if (hitung < 50) {
      hitung++;
    } else {
      Get.snackbar(
        "Stop",
        "Counter tidak boleh lebih dari 50",
        backgroundColor: Colors.red,
        icon: Icon(Icons.warning, color: Colors.white),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void decrement() {
    if (hitung > 0) {
      hitung--;
    } else {
      Get.snackbar(
        "Stop",
        "Counter tidak boleh kurang dari 0",
        backgroundColor: Colors.red,
        icon: Icon(Icons.warning, color: Colors.white),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void gantiNama(String namaBaru) {
    nama.value = namaBaru;
    print("Nama diganti menjadi: $namaBaru");
  }
}
