import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rpl1getx/app/modules/counter/views/counter_view.dart';
import 'package:rpl1getx/app/modules/post/views/post_view.dart';
import 'package:rpl1getx/app/modules/profile/views/profile_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final List<Widget> pages = [CounterView(), PostView(), ProfileView()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => pages[controller.selectedIndex.value]),
      bottomNavigationBar: ConvexAppBar(
        items: const [
          TabItem(icon: Icons.exposure, title: 'Counter'),
          TabItem(icon: Icons.photo_sharp, title: 'Post'),
          TabItem(icon: Icons.account_circle, title: 'Profile'),
        ],
        initialActiveIndex: 0,
        onTap: controller.changePage,
      ),
    );
  }
}
