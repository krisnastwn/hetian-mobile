import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hetian_mobile/app/model/employee.dart';
import 'package:hetian_mobile/app/model/leave.dart';

class FirestoreService {
  static Future<Employee> fetchEmployeeById(String employeeId) async {
    DocumentSnapshot employeeSnapshot = await FirebaseFirestore.instance
        .collection('employee')
        .doc(employeeId)
        .get();

    if (employeeSnapshot.exists) {
      return Employee(
        id: employeeSnapshot.id,
        name: (employeeSnapshot.data() as Map<String, dynamic>)['name']
                as String? ??
            '',
        role:
            (employeeSnapshot.data() as Map<String, dynamic>)['role'] as String,
        totalLeave: (employeeSnapshot.data()
            as Map<String, dynamic>)['total_leave'] as int,
      );
    } else {
      throw Exception('Employee not found');
    }
  }

  static Future<List<Employee>> fetchEmployees() async {
    QuerySnapshot employeeSnapshot =
        await FirebaseFirestore.instance.collection('employee').get();

    List<Employee> employees = employeeSnapshot.docs.map((doc) {
      return Employee(
        id: doc.id,
        name: (doc.data() as Map<String, dynamic>)['name'] as String? ?? '',
        role: (doc.data() as Map<String, dynamic>)['role'] as String,
        totalLeave: (doc.data() as Map<String, dynamic>)['total_leave'] as int,
      );
    }).toList();

    return employees;
  }

  static Future<List<Leave>> fetchLeavesByEmployeeId(String employeeId) async {
    QuerySnapshot leaveSnapshot = await FirebaseFirestore.instance
        .collection('employee')
        .doc(employeeId)
        .collection('leave')
        .get();

    List<Leave> leaves = leaveSnapshot.docs.map((doc) {
      return Leave(
        id: doc.id,
        employeeId: employeeId,
        requestDate: (doc.data() as Map<String, dynamic>)['date_request']
            .toDate()
            .toString(),
        startDate: (doc.data() as Map<String, dynamic>)['start_date']
            .toDate()
            .toString(),
        endDate: (doc.data() as Map<String, dynamic>)['end_date']
            .toDate()
            .toString(),
        reason: (doc.data() as Map<String, dynamic>)['reason'] as String,
        managerApproval: (doc.data() as Map<String, dynamic>)['manager_approval'] as String,
        hrdApproval: (doc.data() as Map<String, dynamic>)['hrd_approval'] as String,
      );
    }).toList();

    return leaves;
  }
}
