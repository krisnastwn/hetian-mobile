import 'package:get/get.dart';

import '../controllers/list_request_leave_controller.dart';

class ListRequestLeaveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListRequestLeaveController>(
      () => ListRequestLeaveController(),
    );
  }
}
