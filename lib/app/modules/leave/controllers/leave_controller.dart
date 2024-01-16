import 'package:get/get.dart';
import 'package:hetian_mobile/app/model/employee.dart';
import 'package:hetian_mobile/app/model/leave.dart';
import 'package:hetian_mobile/app/services/firestore_service.dart';

class LeaveController extends GetxController {
  var leaves = <Leave>[].obs;
  var employees = Employee().obs;
  var isLoading = true.obs;

  void fetchLeaves(String employeeId) async {
    isLoading(true);
    try {
      var fetchedLeaves =
          await FirestoreService.fetchLeavesByEmployeeId(employeeId);
      leaves.assignAll(fetchedLeaves);
    } finally {
      isLoading(false);
    }
  }

  void fetchEmployeeById(String employeeId) async {
    var fetchedEmployee = await FirestoreService.fetchEmployeeById(employeeId);
    employees.value = fetchedEmployee;
  }
}
