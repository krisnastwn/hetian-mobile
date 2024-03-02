import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hetian_mobile/color_schemes.dart';

import '../controllers/navigation_bar_controller.dart';

class NavigationBarView extends StatelessWidget {
  const NavigationBarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<NavigationBarController>(
        init: NavigationBarController(),
        builder: (controller) {
          return PageView(
            controller: controller.pageController,
            children: controller.pages,
            onPageChanged: (index) {
              controller.changePage(index);
            },
          );
        },
      ),
      bottomNavigationBar: Obx(() {
        var controller = Get.find<NavigationBarController>();
        return Theme(
          data: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            backgroundColor: lightColorScheme.background,
            selectedItemColor: lightColorScheme.primary,
            unselectedItemColor: Colors.grey,
            items: controller.items,
            currentIndex: controller.selectedIndex.value,
            onTap: (index) {
              controller.changePage(index);
            },
          ),
        );
      }),
    );
  }
}
