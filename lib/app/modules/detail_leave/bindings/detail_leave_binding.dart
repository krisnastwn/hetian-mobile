import 'package:get/get.dart';

import '../controllers/detail_leave_controller.dart';

class DetailLeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailLeaveController>(
      () => DetailLeaveController(),
    );
  }
}
