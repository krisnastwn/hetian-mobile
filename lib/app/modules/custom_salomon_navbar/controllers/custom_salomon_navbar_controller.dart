import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/color_schemes.dart';

class CustomSalomonNavbarController extends GetxController
    with WidgetsBindingObserver {
  var currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: lightColorScheme.background, // Replace with your color
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor:
              lightColorScheme.background, // Replace with your color
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    }
  }
}
