import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hetian_mobile/app/widgets/toast/custom_toast.dart';
import 'package:intl/intl.dart';

class DetailLeaveController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxBool isEditing = false.obs;

  TextEditingController startDateC = TextEditingController();
  TextEditingController endDateC = TextEditingController();
  TextEditingController reasonC = TextEditingController();

  RxMap<String, dynamic> leaveData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    Map<String, dynamic> data = Get.arguments;

    // Convert Timestamp to DateTime and format it as a string
    startDateC.text = DateFormat('yyyy-MM-dd')
        .format((data["start_date"] as Timestamp).toDate());
    endDateC.text = DateFormat('yyyy-MM-dd')
        .format((data["end_date"] as Timestamp).toDate());
    reasonC.text = data["reason"] ?? "-";

    leaveData.assignAll(data);
  }

  void toggleEdit() {
    isEditing.value = !isEditing.value;
  }

  void selectStartDate() async {
    final DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now().add(const Duration(days: 1)),
        lastDate: DateTime(2100),
        selectableDayPredicate: (date) {
          return date.weekday != DateTime.sunday;
        });

    if (pickedDate != null) {
      FocusManager.instance.primaryFocus?.unfocus();
      startDateC.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      leaveData['start_date'] = Timestamp.fromDate(pickedDate);
    }
  }

  void selectEndDate() async {
    if (startDateC.text.isEmpty) {
      CustomToast.errorToast(
          'Perhatian', 'Silahkan pilih tanggal mulai terlebih dahulu');
      return;
    }
    DateTime initialDate = DateTime.now();
    DateTime startDate = DateTime.now();
    if (startDateC.text.isNotEmpty) {
      startDate = DateFormat('dd-MM-yyyy').parse(startDateC.text);
      if (startDate.isAfter(DateTime.now())) {
        initialDate = startDate;
      }
    }

    final DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: initialDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        selectableDayPredicate: (date) {
          return date.weekday != DateTime.sunday &&
              date.isAfter(DateFormat('dd-MM-yyyy')
                  .parse(startDateC.text)
                  .subtract(const Duration(days: 1)));
        });
    if (pickedDate != null) {
      FocusManager.instance.primaryFocus?.unfocus();
      endDateC.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      leaveData['end_date'] = Timestamp.fromDate(pickedDate);
    }
  }

  Future<Map<String, dynamic>> editLeaveRequest(String docId,
      String newStartDate, String newEndDate, String reason) async {
    try {
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

      DocumentReference docRef = firestore
          .collection("employee")
          .doc(auth.currentUser!.uid)
          .collection("leave")
          .doc(docId);
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists &&
          (docSnapshot.data() as Map<String, dynamic>)['hrd_approval'] ==
              'Disetujui') {
        // Calculate the duration of the requested leave
        DateTime startDate =
            (docSnapshot.get('start_date') as Timestamp).toDate();
        DateTime endDate = (docSnapshot.get('end_date') as Timestamp).toDate();
        int requestedLeaveDuration = endDate.difference(startDate).inDays + 1;

        // Parse the new chosen start and end dates
        DateTime newStartDate = DateFormat('dd-MM-yyyy').parse(startDateC.text);
        DateTime newEndDate = DateFormat('dd-MM-yyyy').parse(endDateC.text);

        // Calculate the duration of the new requested leave
        int newRequestedLeaveDuration = 0;
        for (int i = 0; i <= newEndDate.difference(newStartDate).inDays; i++) {
          if (newStartDate.add(Duration(days: i)).weekday != DateTime.sunday) {
            newRequestedLeaveDuration++;
          }
        }

        // Fetch the total_leave from the employee's document
        DocumentReference employeeRef =
            firestore.collection("employee").doc(auth.currentUser!.uid);
        DocumentSnapshot employeeSnapshot = await employeeRef.get();

        int totalLeave = await employeeSnapshot.get('total_leave');

        // Update total_leave and used_leave based on the difference
        await employeeRef.update({
          'used_leave': FieldValue.increment(-requestedLeaveDuration),
          'total_leave': FieldValue.increment(requestedLeaveDuration),
        }).then((_) async {
          DocumentSnapshot updatedEmployeeSnapshot = await employeeRef.get();
          Map<String, dynamic> employeeData =
              updatedEmployeeSnapshot.data() as Map<String, dynamic>;
          totalLeave = employeeData['total_leave'];
        });

        // Check if total_leave is enough
        if (totalLeave < newRequestedLeaveDuration) {
          Get.back(); // Close the loading indicator
          CustomToast.errorToast('Gagal', 'Cuti tidak cukup');
          await employeeRef.update({
            'used_leave': FieldValue.increment(requestedLeaveDuration),
            'total_leave': FieldValue.increment(-requestedLeaveDuration),
          });
          return {};
        }

        await docRef.update({
          'date_request': Timestamp.fromDate(DateTime.now()),
          'start_date': Timestamp.fromDate(newStartDate),
          'end_date': Timestamp.fromDate(newEndDate),
          'manager_approval': 'Belum Disetujui',
          'hrd_approval': 'Belum Disetujui',
          'reason': reason,
        });

        Get.back(); // Close the loading indicator

        CustomToast.successToast('Berhasil', 'Berhasil mengubah cuti');
        await Future.delayed(const Duration(seconds: 2));

        // Fetch the updated leave data
        DocumentSnapshot updatedDocSnapshot = await docRef.get();
        Map<String, dynamic> updatedLeaveData =
            updatedDocSnapshot.data() as Map<String, dynamic>;

        leaveData.assignAll(updatedLeaveData);
        isEditing.value = false;
        return updatedLeaveData;
      } else if (docSnapshot.exists &&
              (docSnapshot.data() as Map<String, dynamic>)['hrd_approval'] ==
                  'Belum Disetujui' ||
          (docSnapshot.data() as Map<String, dynamic>)['hrd_approval'] ==
              'Tidak Disetujui') {
        // Parse the new chosen start and end dates
        DateTime newStartDate = DateFormat('dd-MM-yyyy').parse(startDateC.text);
        DateTime newEndDate = DateFormat('dd-MM-yyyy').parse(endDateC.text);

        // Calculate the duration of the new requested leave
        int newRequestedLeaveDuration = 0;
        for (int i = 0; i <= newEndDate.difference(newStartDate).inDays; i++) {
          if (newStartDate.add(Duration(days: i)).weekday != DateTime.sunday) {
            newRequestedLeaveDuration++;
          }
        }

        // Fetch the total_leave from the employee's document
        DocumentReference employeeRef =
            firestore.collection("employee").doc(auth.currentUser!.uid);
        DocumentSnapshot employeeSnapshot = await employeeRef.get();
        int totalLeave = employeeSnapshot.get('total_leave');

        // Check if total_leave is enough
        if (newRequestedLeaveDuration > totalLeave) {
          Get.back(); // Close the loading indicator
          CustomToast.errorToast('Gagal', 'Cuti tidak cukup');
          return {};
        }

        // Convert the DateTime objects to Timestamps
        Timestamp newStartTimestamp = Timestamp.fromDate(newStartDate);
        Timestamp newEndTimestamp = Timestamp.fromDate(newEndDate);

        await docRef.update({
          'date_request': Timestamp.fromDate(DateTime.now()),
          'start_date': newStartTimestamp,
          'end_date': newEndTimestamp,
          'manager_approval': 'Belum Disetujui',
          'hrd_approval': 'Belum Disetujui',
          'reason': reason,
        });

        Get.back(); // Close the loading indicator

        CustomToast.successToast('Berhasil', 'Berhasil mengubah cuti');
        await Future.delayed(const Duration(seconds: 2));

        // Fetch the updated leave data
        DocumentSnapshot updatedDocSnapshot = await docRef.get();
        Map<String, dynamic> updatedLeaveData =
            updatedDocSnapshot.data() as Map<String, dynamic>;
        leaveData.assignAll(updatedLeaveData);
        isEditing.value = false;
        return updatedLeaveData;
      } else {
        Get.back(); // Close the loading indicator
        CustomToast.errorToast('Gagal', 'Gagal mengubah cuti');
        isEditing.value = false;
        throw Exception('Data tidak ditemukan');
      }
    } catch (e) {
      Get.back(); // Close the loading indicator
      CustomToast.errorToast('Gagal', 'Terjadi kesalahan saat mengubah cuti');
      isEditing.value = false;
      rethrow;
    }
  }

  Future<void> cancelLeaveRequest(String id) async {
    Get.dialog(
      AlertDialog(
        buttonPadding: EdgeInsets.zero,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: const Text('Konfirmasi'),
        content: const Text('Apakah anda yakin ingin membatalkan cuti ini?'),
        actions: [
          TextButton(
            child: const Text('Kembali'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: const Text('Batalkan',
                style: TextStyle(color: Color(0xffdf1b1b))),
            onPressed: () async {
              Get.back();
              try {
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

                DocumentReference leaveRef = firestore
                    .collection("employee")
                    .doc(auth.currentUser!.uid)
                    .collection("leave")
                    .doc(id);
                DocumentSnapshot docSnapshot = await leaveRef.get();
                var leaveData = docSnapshot.data() as Map<String, dynamic>;
                if (docSnapshot.exists &&
                    leaveData['cancel_status'] == 'Belum Dibatalkan' &&
                    leaveData['manager_approval'] == 'Disetujui' &&
                    leaveData['hrd_approval'] == 'Disetujui') {
                  await leaveRef.update({
                    'cancel_status': 'Dibatalkan',
                    'manager_approval': 'Belum Disetujui',
                    'hrd_approval': 'Belum Disetujui',
                    'date_request': Timestamp.fromDate(DateTime.now()),
                  });

                  Get.back(); // Close the loading indicator
                  CustomToast.successToast('Berhasil',
                      'Berhasil mengirim pengajuan pembatalan cuti');
                  await Future.delayed(const Duration(seconds: 2));
                  Get.back(closeOverlays: true); //back to homepage
                } else {
                  await leaveRef.delete();
                  Get.back(); // Close the loading indicator
                  CustomToast.successToast(
                      'Berhasil', 'Berhasil membatalkan pengajuan cuti');
                  await Future.delayed(const Duration(seconds: 2));
                  Get.back(closeOverlays: true); //back to homepage
                }
              } catch (e) {
                Get.back(); // Close the loading indicator
                CustomToast.errorToast(
                    'Gagal', 'Terjadi kesalahan saat membatalkan cuti');
              }
            },
          ),
        ],
      ),
    );
  }
}
