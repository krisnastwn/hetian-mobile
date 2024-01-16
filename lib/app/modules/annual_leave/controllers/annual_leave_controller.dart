import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnnualLeaveController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController reasonC = TextEditingController();
  TextEditingController jobC = TextEditingController();
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
    jobC.dispose();
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
    );

    if (pickedDate != null) {
      startDateC.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    }
  }

  void selectEndDate() async {
    if (startDateC.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Silahkan pilih tanggal mulai terlebih dahulu',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
      selectableDayPredicate: (date) => date.isAfter(DateFormat('dd-MM-yyyy')
          .parse(startDateC.text)
          .subtract(const Duration(days: 1))),
    );

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
        jobC.text.isEmpty ||
        dateRequestC.text.isEmpty ||
        startDateC.text.isEmpty ||
        endDateC.text.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Semua form harus diisi',
        backgroundColor: AppColor.error,
        colorText: Colors.white,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
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
                print('Submitting form...'); // Add this line

                // Fetch the employee's data
                final employeeDoc = await FirebaseFirestore.instance
                    .collection('employee')
                    .doc(uid)
                    .get();

                // Check if total_leave is 0
                if (employeeDoc.data()?['total_leave'] == 0) {
                  print('No leave left'); // Add this line
                  Get.snackbar(
                    'Gagal',
                    'Anda tidak memiliki cuti tersisa',
                    backgroundColor: AppColor.error,
                    colorText: Colors.white,
                  );

                  startDateC.clear();
                  endDateC.clear();
                  reasonC.clear();
                  Future.delayed(const Duration(seconds: 2), () {
                    Get.back(closeOverlays: true);
                  });
                  return; // Return from the function
                }

                final leaveData = {
                  'name': nameC.text,
                  'reason': reasonC.text,
                  'job': jobC.text,
                  'date_request': dateRequestC.text,
                  'start_date': startDateC.text,
                  'end_date': endDateC.text,
                  'status': 'Belum Disetujui',
                };

                await FirebaseFirestore.instance
                    .collection('employee')
                    .doc(uid)
                    .collection('leave')
                    .add(leaveData);

                print('Form submitted successfully'); // Add this line
                Get.snackbar(
                  'Sukses',
                  'Pengajuan cuti berhasil dikirim',
                  backgroundColor: AppColor.success,
                  colorText: Colors.white,
                );

                startDateC.clear();
                endDateC.clear();
                reasonC.clear();
                Future.delayed(const Duration(seconds: 2), () {
                  Get.back(closeOverlays: true);
                });
              } catch (e) {
                print('Error submitting leave form: $e');
                Get.snackbar(
                  'Gagal',
                  'Pengajuan cuti gagal dikirim',
                  backgroundColor: AppColor.error,
                  colorText: Colors.white,
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
