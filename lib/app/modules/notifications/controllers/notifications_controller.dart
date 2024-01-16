import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/color_schemes.dart';

class NotificationsController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: lightColorScheme.primary,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  void onClose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    super.onClose();
  }
}
