import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ListRequestLeaveController extends GetxController {
  Stream<QuerySnapshot<Map<String, dynamic>>> streamLeaveRequest() async* {
    yield* FirebaseFirestore.instance
        .collectionGroup("leave")
        .where('status', isEqualTo: 'Belum Disetujui')
        .orderBy("date_request", descending: true)
        .snapshots();
  }

  void approveLeave(String leaveId, String employeeId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text(
            'Apakah anda yakin ingin menyetujui pengajuan cuti ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: const Text('Setujui'),
            onPressed: () async {
              try {
                final employeeDoc = await FirebaseFirestore.instance
                    .collection('employee')
                    .doc(employeeId)
                    .get();

                final leaveDoc = await FirebaseFirestore.instance
                    .collection('employee')
                    .doc(employeeId)
                    .collection('leave')
                    .doc(leaveId)
                    .get();

                if (employeeDoc.exists && leaveDoc.exists) {
                  int totalLeave = employeeDoc.data()?['total_leave'] ?? 0;
                  int usedLeave = employeeDoc.data()?['used_leave'] ?? 0;

                  var format = DateFormat("dd-MM-yyyy");
                  DateTime startDate =
                      format.parse(leaveDoc.data()?['start_date']);
                  DateTime endDate = format.parse(leaveDoc.data()?['end_date']);
                  int leaveDays = endDate.difference(startDate).inDays + 1;

                  if (totalLeave >= leaveDays) {
                    totalLeave -= leaveDays;
                    usedLeave += leaveDays;

                    await FirebaseFirestore.instance
                        .collection('employee')
                        .doc(employeeId)
                        .update({
                      'total_leave': totalLeave,
                      'used_leave': usedLeave
                    });

                    await FirebaseFirestore.instance
                        .collection('employee')
                        .doc(employeeId)
                        .collection('leave')
                        .doc(leaveId)
                        .update({'status': 'Disetujui'});
                  } else {
                    print('Not enough leave left');
                    // Handle the error accordingly
                  }
                } else {
                  print('Employee or leave request not found');
                  // Handle the error accordingly
                }

                Get.back();
              } catch (e) {
                if (e is FirebaseException && e.code == 'not-found') {
                  print('Document not found');
                  // Handle the error accordingly
                } else {
                  rethrow;
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void rejectLeave(String leaveId, String employeeId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi'),
        content:
            const Text('Apakah anda yakin ingin menolak pengajuan cuti ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: const Text('Tolak'),
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('employee')
                    .doc(employeeId)
                    .collection('leave')
                    .doc(leaveId)
                    .update({'status': 'Tidak Disetujui'});
                Get.back();
              } catch (e) {
                if (e is FirebaseException && e.code == 'not-found') {
                  print('Document not found');
                  // Handle the error accordingly
                } else {
                  rethrow;
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
