import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/widgets/toast/custom_toast.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnnualLeaveController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController reasonC = TextEditingController();
  TextEditingController roleC = TextEditingController();
  TextEditingController dateRequestC = TextEditingController();
  TextEditingController startDateC = TextEditingController();
  TextEditingController endDateC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  RxBool isLoading = false.obs;

  @override
  void onClose() {
    nameC.dispose();
    reasonC.dispose();
    roleC.dispose();
    dateRequestC.dispose();
    startDateC.dispose();
    endDateC.dispose();
    super.onClose();
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
      startDateC.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    }
  }

  void selectEndDate() async {
    if (startDateC.text.isEmpty) {
      CustomToast.errorToast(
          'Perhatian', 'Silahkan pilih tanggal mulai terlebih dahulu');
      return;
    }
    DateTime initialDate = DateTime.now();
    if (startDateC.text.isNotEmpty) {
      DateTime startDate = DateFormat('dd-MM-yyyy').parse(startDateC.text);
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
      endDateC.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("employee").doc(uid).snapshots();
  }

  Future<void> submitLeaveForm() async {
    final uid = auth.currentUser!.uid;

    if (nameC.text.isEmpty ||
        reasonC.text.isEmpty ||
        roleC.text.isEmpty ||
        dateRequestC.text.isEmpty ||
        startDateC.text.isEmpty ||
        endDateC.text.isEmpty) {
      CustomToast.errorToast('Perhatian', 'Semua form harus diisi');
      return;
    }

    Get.dialog(
      AlertDialog(
        buttonPadding: EdgeInsets.zero,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: const Text('Konfirmasi'),
        content:
            const Text('Apakah anda yakin ingin mengirim pengajuan cuti ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: const Text('Kirim'),
            onPressed: () async {
              try {
                isLoading.value = true;
                Get.back();

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

                // Fetch the employee's data
                final employeeDoc = await FirebaseFirestore.instance
                    .collection('employee')
                    .doc(uid)
                    .get();

                // Check if total_leave is 0
                if (employeeDoc.data()?['total_leave'] == 0) {
                  Get.back(); // Close the loading indicator
                  CustomToast.errorToast(
                      'Perhatian', 'Anda tidak memiliki cuti tersisa');
                  startDateC.clear();
                  endDateC.clear();
                  reasonC.clear();
                  return; // Return from the function
                }

                // Calculate the duration of the requested leave
                DateTime startDate =
                    DateFormat('dd-MM-yyyy').parse(startDateC.text);
                DateTime endDate =
                    DateFormat('dd-MM-yyyy').parse(endDateC.text);
                DateTime dateRequest =
                    DateFormat('dd-MM-yyyy').parse(dateRequestC.text);

                int requestedLeaveDuration = 0;
                for (int i = 0;
                    i <= endDate.difference(startDate).inDays;
                    i++) {
                  if (startDate.add(Duration(days: i)).weekday !=
                      DateTime.sunday) {
                    requestedLeaveDuration++;
                  }
                }

                // Convert the DateTime objects to Timestamps
                Timestamp startTimestamp = Timestamp.fromDate(startDate);
                Timestamp endTimestamp = Timestamp.fromDate(endDate);
                Timestamp dateRequestTimestamp =
                    Timestamp.fromDate(dateRequest);

                // Check if total_leave is enough for the requested leave
                if (employeeDoc.data()?['total_leave'] <
                    requestedLeaveDuration) {
                  Get.back(); // Close the loading indicator
                  CustomToast.errorToast(
                    'Gagal',
                    'Anda tidak memiliki cukup cuti untuk periode ini',
                  );

                  startDateC.clear();
                  endDateC.clear();
                  reasonC.clear();

                  return; // Return from the function
                }

                Map<String, dynamic> leaveData = {
                  'leave_id': DateTime.now().millisecondsSinceEpoch.toString(),
                  'name': nameC.text,
                  'reason': reasonC.text,
                  'role': roleC.text,
                  'date_request': dateRequestTimestamp,
                  'start_date': startTimestamp,
                  'end_date': endTimestamp,
                  'manager_approval': 'Belum Disetujui',
                  'hrd_approval': 'Belum Disetujui',
                };

                await FirebaseFirestore.instance
                    .collection('employee')
                    .doc(uid)
                    .collection('leave')
                    .add(leaveData);
                Get.back(); // Close the loading indicator

                CustomToast.successToast(
                  'Sukses',
                  'Pengajuan cuti berhasil dikirim',
                );

                startDateC.clear();
                endDateC.clear();
                reasonC.clear();
              } catch (e) {
                Get.back(); // Close the loading indicator
                CustomToast.errorToast(
                  'Gagal',
                  'Pengajuan cuti gagal dikirim',
                );
              } finally {
                isLoading.value = false;
              }
            },
          ),
        ],
      ),
    );
  }
}
