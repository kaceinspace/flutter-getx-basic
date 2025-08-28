import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/counter_controller.dart';

class CounterView extends GetView<CounterController> {
  CounterController c = Get.put(CounterController());
  CounterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CounterView'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => Text(
                "Hitungan ke:${c.hitung.toString()}",
                style: TextStyle(fontSize: c.hitung.toDouble()),
              ),
            ),

            Obx(
              () => Text(
                "Nama: ${c.nama.value}",
                style: TextStyle(fontSize: c.hitung.toDouble()),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: c.decrement, child: Text('-')),
                ElevatedButton(onPressed: c.increment, child: Text('+')),
              ],
            ),
            ElevatedButton(
              onPressed: () => c.gantiNama("Bukan RPL KU TKR"),
              child: Text('Ganti Nama'),
            ),
          ],
        ),
      ),
    );
  }
}
