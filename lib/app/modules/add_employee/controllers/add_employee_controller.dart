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

  final roles = [
    'HRD',
    'Manager',
    'Supervisor',
    'Accounting',
    'Leader',
    'PPC',
    'Operator',
  ];
  final selectedRole = 'HRD'.obs;

  String getDefaultPassword() {
    return CompanyData.defaultPassword;
  }

  Future<void> addEmployee() async {
    if (idC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty &&
        selectedRole.isNotEmpty) {
      isLoading.value = true;
      CustomAlertDialog.confirmAdmin(
        title: 'Konfirmasi',
        message: 'Apakah anda yakin ingin menambahkan ${nameC.text}?',
        onCancel: () {
          isLoading.value = false;
          Get.back();
        },
        onConfirm: () async {
          Get.back(); //close dialog confirm
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

          if (isLoadingCreatePegawai.isFalse) {
            await createEmployeeData();
            isLoading.value = false;
          }
        },
        controller: adminPassC,
      );
    } else {
      isLoading.value = false;
      CustomToast.errorToast('Gagal', 'Harap isi semua kolom');
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
            "role": selectedRole.value,
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

          Get.back(); //close dialog loading
          Get.back(); //close form screen
          CustomToast.successToast('Sukses', 'Karyawan berhasil ditambahkan');
          idC.clear();
          nameC.clear();
          emailC.clear();
          adminPassC.clear();
          isLoadingCreatePegawai.value = false;
        }
      } on FirebaseAuthException catch (e) {
        isLoadingCreatePegawai.value = false;
        if (e.code == 'weak-password') {
          Get.back(); //close dialog loading
          adminPassC.clear();
          CustomToast.errorToast('Gagal', 'Kata sandi terlalu lemah');
        } else if (e.code == 'email-already-in-use') {
          Get.back(); //close dialog loading
          adminPassC.clear();
          CustomToast.errorToast('Gagal', 'Email sudah digunakan');
        } else if (e.code == 'wrong-password') {
          Get.back(); //close dialog loading
          adminPassC.clear();
          CustomToast.errorToast('Gagal', 'Kata sandi salah');
        } else {
          Get.back(); //close dialog loading
          adminPassC.clear();
          CustomToast.errorToast('Gagal', 'error : ${e.code}');
        }
      } catch (e) {
        Get.back(); //close dialog loading
        adminPassC.clear();
        isLoadingCreatePegawai.value = false;
        CustomToast.errorToast('Gagal', 'error : ${e.toString()}');
      }
    } else {
      adminPassC.clear();
      CustomToast.errorToast('Gagal', 'Harap isi semua form');
    }
  }
}
