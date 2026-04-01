import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bottom_menu_controller.dart';
import '../../home/views/home_view.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../profile/views/profile_view.dart';

class BottomMenuView extends GetView<BottomMenuController> {
  const BottomMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      const HomeView(),
      const DashboardView(),
      const _CartPlaceholder(),
      const ProfileView(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Obx(
        () =>
            IndexedStack(index: controller.currentIndex.value, children: pages),
      ),
      extendBody: true,
      bottomNavigationBar: Obx(() => _buildBottomNav(controller)),
    );
  }

  Widget _buildBottomNav(BottomMenuController ctrl) {
    final items = [
      _NavItem(icon: Icons.home_rounded, label: 'Home'),
      _NavItem(icon: Icons.menu_book_rounded, label: 'Library'),
      _NavItem(icon: Icons.shopping_bag_rounded, label: 'Cart'),
      _NavItem(icon: Icons.person_rounded, label: 'Profile'),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E3A8A),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(items.length, (i) {
          final isActive = ctrl.currentIndex.value == i;
          return GestureDetector(
            onTap: () => ctrl.changeTab(i),
            behavior: HitTestBehavior.opaque,
            child: AnimatedScale(
              scale: isActive ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: TextStyle(
                          color: Colors.transparent,
                          fontSize: 0,
                        ),
                        child: Icon(
                          items[i].icon,
                          size: 24,
                          color: isActive
                              ? const Color(0xFFFACC15)
                              : Colors.white.withOpacity(0.4),
                        ),
                      ),
                      if (isActive)
                        Positioned(
                          bottom: -6,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFACC15),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFFACC15,
                                  ).withOpacity(0.8),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    items[i].label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: isActive
                          ? const Color(0xFFFACC15)
                          : Colors.white.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  _NavItem({required this.icon, required this.label});
}

class _CartPlaceholder extends StatelessWidget {
  const _CartPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Keranjang',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Segera hadir',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
