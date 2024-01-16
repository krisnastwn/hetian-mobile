import 'package:get/get.dart';

import '../controllers/annual_leave_controller.dart';

class AnnualLeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AnnualLeaveController>(
      () => AnnualLeaveController(),
    );
  }
}
