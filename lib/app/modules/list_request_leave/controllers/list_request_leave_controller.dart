import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/widgets/toast/custom_toast.dart';

class ListRequestLeaveController extends GetxController {

  Stream<QuerySnapshot<Object?>> streamLeaveRequest(String role) async* {
    Query query = FirebaseFirestore.instance.collectionGroup("leave");

    if (role == "Manager") {
      query = query.where('manager_approval', isEqualTo: 'Belum Disetujui');
    } else if (role == "HRD") {
      query = query.where('hrd_approval', isEqualTo: 'Belum Disetujui');
    }

    yield* query.orderBy("date_request", descending: true).snapshots();
  }

  void approveLeave(String leaveId, String employeeId, String role) {
    Get.dialog(
      AlertDialog(
        buttonPadding: EdgeInsets.zero,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                Get.back(); // Close the dialog

                // Show the loading indicator
                Get.dialog(
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromRGBO(0, 103, 124, 1),
                        ),
                      ),
                    ),
                  ), // Show the loading indicator
                  barrierDismissible:
                      false, // Prevent the dialog from closing when the user taps outside it
                );
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

                  // Check if the 'start_date' and 'end_date' fields exist and are Timestamps
                  if (leaveDoc.data()?['start_date'] is Timestamp &&
                      leaveDoc.data()?['end_date'] is Timestamp) {
                    Timestamp startTimestamp =
                        leaveDoc.data()?['start_date'] as Timestamp;
                    Timestamp endTimestamp =
                        leaveDoc.data()?['end_date'] as Timestamp;

                    // Convert the Timestamps to DateTime objects
                    DateTime startDate = startTimestamp.toDate();
                    DateTime endDate = endTimestamp.toDate();

                    int requestedLeaveDuration = 0;
                    for (int i = 0;
                        i <= endDate.difference(startDate).inDays;
                        i++) {
                      if (startDate.add(Duration(days: i)).weekday !=
                          DateTime.sunday) {
                        requestedLeaveDuration++;
                      }
                    }

                    if (totalLeave >= requestedLeaveDuration) {
                      totalLeave -= requestedLeaveDuration;
                      usedLeave += requestedLeaveDuration;

                      if (role == "Manager") {
                        await FirebaseFirestore.instance
                            .collection('employee')
                            .doc(employeeId)
                            .collection('leave')
                            .doc(leaveId)
                            .update({'manager_approval': 'Disetujui'});
                      } else if (role == "HRD") {
                        await FirebaseFirestore.instance
                            .collection('employee')
                            .doc(employeeId)
                            .collection('leave')
                            .doc(leaveId)
                            .update({'hrd_approval': 'Disetujui'});
                      }

                      // Fetch the leaveDoc again to get the updated manager_approval and hrd_approval fields
                      final updatedLeaveDoc = await FirebaseFirestore.instance
                          .collection('employee')
                          .doc(employeeId)
                          .collection('leave')
                          .doc(leaveId)
                          .get();

                      Map<String, dynamic>? updatedData =
                          updatedLeaveDoc.data();

                      if (updatedData != null &&
                          updatedData['manager_approval'] == 'Disetujui' &&
                          updatedData['hrd_approval'] == 'Disetujui') {
                        // If approved, update total_leave and used_leave
                        await FirebaseFirestore.instance
                            .collection('employee')
                            .doc(employeeId)
                            .update({
                          'total_leave': totalLeave,
                          'used_leave': usedLeave
                        });
                      }
                      Get.back();
                      CustomToast.successToast(
                          'Berhasil', 'Pengajuan cuti berhasil disetujui');
                    } else {
                      Get.back();
                      CustomToast.errorToast('Gagal', 'Sisa cuti tidak cukup');
                    }
                  } else {
                    Get.back();
                    CustomToast.errorToast('Gagal', 'Data tidak valid');
                  }
                } else {
                  Get.back();
                  CustomToast.errorToast(
                      'Gagal', 'Pengajuan cuti tidak ditemukan');
                }
                Get.back();
              } catch (e) {
                if (e is FirebaseException && e.code == 'not-found') {
                  Get.back();
                  CustomToast.errorToast('Gagal', 'Data tidak ditemukan');
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

  void rejectLeave(String leaveId, String employeeId, String role) {
    Get.dialog(
      AlertDialog(
        buttonPadding: EdgeInsets.zero,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                Get.back(); // Close the dialog

                // Show the loading indicator
                Get.dialog(
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color.fromRGBO(0, 103, 124, 1),
                        ),
                      ),
                    ),
                  ), // Show the loading indicator
                  barrierDismissible:
                      false, // Prevent the dialog from closing when the user taps outside it
                );
                if (role == "Manager") {
                  await FirebaseFirestore.instance
                      .collection('employee')
                      .doc(employeeId)
                      .collection('leave')
                      .doc(leaveId)
                      .update({'manager_approval': 'Tidak Disetujui'});
                } else if (role == "HRD") {
                  await FirebaseFirestore.instance
                      .collection('employee')
                      .doc(employeeId)
                      .collection('leave')
                      .doc(leaveId)
                      .update({'hrd_approval': 'Tidak Disetujui'});
                }
                Get.back();
                CustomToast.successToast(
                    'Berhasil', 'Pengajuan cuti berhasil ditolak');
              } catch (e) {
                if (e is FirebaseException && e.code == 'not-found') {
                  Get.back();
                  CustomToast.errorToast('Gagal', 'Data tidak ditemukan');
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
