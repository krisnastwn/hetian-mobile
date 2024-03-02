import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/modules/annual_leave/views/annual_leave_view.dart';
import 'package:hetian_mobile/app/modules/home/views/home_view.dart';
import 'package:hetian_mobile/app/modules/profile/views/profile_view.dart';

class NavigationBarController extends GetxController {
  RxInt selectedIndex = 0.obs;
  PageController pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  List<Widget> pages = [
    const HomeView(),
    const AnnualLeaveView(),
    const ProfileView(),
  ];

  List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(
      icon: FaIcon(
        FontAwesomeIcons.house,
        size: 22,
      ),
      label: "Beranda",
    ),
    const BottomNavigationBarItem(
      icon: FaIcon(
        FontAwesomeIcons.solidCalendarCheck,
        size: 22,
      ),
      label: "Cuti",
    ),
    const BottomNavigationBarItem(
      icon: FaIcon(
        FontAwesomeIcons.solidUser,
        size: 22,
      ),
      label: "Akun",
    ),
  ];

  void changePage(int index) {
    selectedIndex.value = index;
    pageController.jumpToPage(index);
  }
}
