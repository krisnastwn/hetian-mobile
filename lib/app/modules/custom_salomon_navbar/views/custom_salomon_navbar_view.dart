import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/modules/annual_leave/views/annual_leave_view.dart';
import 'package:hetian_mobile/app/modules/home/views/home_view.dart';
import 'package:hetian_mobile/app/modules/profile/views/profile_view.dart';
import 'package:hetian_mobile/color_schemes.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../controllers/custom_salomon_navbar_controller.dart';

class CustomSalomonNavbarView extends GetView<CustomSalomonNavbarController> {
  CustomSalomonNavbarView({super.key});

  final List<Widget> pages = [
    const HomeView(),
    const AnnualLeaveView(),
    const ProfileView(),
  ];

  final List<SalomonBottomBarItem> items = [
    SalomonBottomBarItem(
      icon: const Icon(Icons.home),
      title: const Text("Beranda"),
      selectedColor: lightColorScheme.primary,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.add),
      title: const Text("Ajukan Cuti"),
      selectedColor: lightColorScheme.primary,
    ),
    SalomonBottomBarItem(
      icon: const Icon(Icons.person),
      title: const Text("Profil"),
      selectedColor: lightColorScheme.primary,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomSalomonNavbarController>();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: lightColorScheme.background,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return Scaffold(
      body: Obx(() => pages[controller.currentIndex.value]),
      bottomNavigationBar: Obx(
        () => Material(
          elevation: 8,
          child: SalomonBottomBar(
            margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            currentIndex: controller.currentIndex.value,
            onTap: (index) => controller.changePage(index),
            items: items,
          ),
        ),
      ),
    );
  }
}
