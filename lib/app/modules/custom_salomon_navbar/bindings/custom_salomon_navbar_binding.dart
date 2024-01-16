import 'package:get/get.dart';

import '../controllers/custom_salomon_navbar_controller.dart';

class CustomSalomonNavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomSalomonNavbarController>(
      () => CustomSalomonNavbarController(),
    );
  }
}
