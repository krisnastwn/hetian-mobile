import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/widgets/dialog/custom_alert_dialog.dart';
import 'package:hetian_mobile/app/widgets/toast/custom_toast.dart';
import 'package:hetian_mobile/company_data.dart';

class AddEmployeeController extends GetxController {
  @override
  onClose() {
    idC.dispose();
    nameC.dispose();
    emailC.dispose();
    adminPassC.dispose();
  }

  RxBool isLoading = false.obs;
  RxBool isLoadingCreatePegawai = false.obs;

  TextEditingController idC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController adminPassC = TextEditingController();
  FocusNode idFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final jobs = [
    'Manager',
    'Supervisor',
    'HRD',
    'Accounting',
    'Leader',
    'PPC',
    'Operator',
  ];
  final selectedJob = 'HRD'.obs;

  String getDefaultPassword() {
    return CompanyData.defaultPassword;
  }

  String getDefaultRole() {
    return CompanyData.defaultRole;
  }

  Future<void> addEmployee() async {
    if (idC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        selectedJob.isNotEmpty) {
      isLoading.value = true;
      CustomAlertDialog.confirmAdmin(
        title: 'Konfirmasi',
        message: 'Apakah anda yakin ingin menambahkan ${nameC.text}?',
        onCancel: () {
          isLoading.value = false;
          Get.back();
        },
        onConfirm: () async {
          if (isLoadingCreatePegawai.isFalse) {
            await createEmployeeData();
            isLoading.value = false;
          }
        },
        controller: adminPassC,
      );
    } else {
      isLoading.value = false;
      CustomToast.errorToast('Gagal', 'Harap isi semua form');
    }
  }

  createEmployeeData() async {
    if (adminPassC.text.isNotEmpty) {
      isLoadingCreatePegawai.value = true;
      String adminEmail = auth.currentUser!.email!;
      try {
        //checking if the pass is match
        await auth.signInWithEmailAndPassword(
            email: adminEmail, password: adminPassC.text);
        //get default password
        String defaultPassword = getDefaultPassword();
        String defaultRole = getDefaultRole();
        // if the password is match, then continue the create user process
        UserCredential employeeCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: defaultPassword,
        );

        if (employeeCredential.user != null) {
          String uid = employeeCredential.user!.uid;
          DocumentReference employee =
              firestore.collection("employee").doc(uid);
          await employee.set({
            "employee_id": idC.text,
            "name": nameC.text,
            "email": emailC.text,
            "role": defaultRole,
            "job": selectedJob.value,
            "created_at": DateTime.now().toIso8601String(),
            'total_leave': 12,
            'used_leave': 0,
          });

          await employeeCredential.user!.sendEmailVerification();

          //need to logout because the current user is changed after adding new user
          auth.signOut();
          // need to relogin to admin account
          await auth.signInWithEmailAndPassword(
              email: adminEmail, password: adminPassC.text);

          // clear form

          Get.back(); //close dialog
          Get.back(); //close form screen
          CustomToast.successToast('Sukses', 'Pegawai berhasil ditambahkan');

          isLoadingCreatePegawai.value = false;
        }
      } on FirebaseAuthException catch (e) {
        isLoadingCreatePegawai.value = false;
        if (e.code == 'weak-password') {
          CustomToast.errorToast('Gagal', 'Kata sandi terlalu lemah');
        } else if (e.code == 'email-already-in-use') {
          CustomToast.errorToast('Gagal', 'Email sudah digunakan');
        } else if (e.code == 'wrong-password') {
          CustomToast.errorToast('Gagal', 'Kata sandi salah');
        } else {
          CustomToast.errorToast('Gagal', 'error : ${e.code}');
        }
      } catch (e) {
        isLoadingCreatePegawai.value = false;
        CustomToast.errorToast('Gagal', 'error : ${e.toString()}');
      }
    } else {
      CustomToast.errorToast('Gagal', 'Harap isi semua form');
    }
  }
}
