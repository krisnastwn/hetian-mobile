import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/model/employee.dart';
import 'package:hetian_mobile/app/services/firestore_service.dart';

class EmployeeController extends GetxController {
  var employees = <Employee>[].obs;
  var isLoading = true.obs;
  var filteredEmployees = <Employee>[].obs;
  TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    fetchEmployees();
    filteredEmployees.value = employees;
    super.onInit();
  }

  void fetchEmployees() async {
    isLoading(true);
    try {
      var fetchedEmployees = await FirestoreService.fetchEmployees();
      employees.assignAll(fetchedEmployees);
    } finally {
      isLoading(false);
    }
  }

  void filterEmployees(String query) {
    if (query.isEmpty) {
      filteredEmployees.value = employees;
    } else {
      filteredEmployees.value = employees
          .where((employee) => employee.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
