import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/widgets/toast/custom_toast.dart';

class ChangePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool oldPassObs = true.obs;
  RxBool newPassObs = true.obs;
  RxBool newPassCObs = true.obs;
  TextEditingController currentPassC = TextEditingController();
  TextEditingController newPassC = TextEditingController();
  TextEditingController confirmNewPassC = TextEditingController();
  FocusNode currentPassFocusNode = FocusNode();
  FocusNode newPassFocusNode = FocusNode();
  FocusNode confirmNewPassFocusNode = FocusNode();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> updatePassword() async {
    if (currentPassC.text.isNotEmpty &&
        newPassC.text.isNotEmpty &&
        confirmNewPassC.text.isNotEmpty) {
      if (newPassC.text == confirmNewPassC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;
          // checking if the current password is true
          await auth.signInWithEmailAndPassword(
              email: emailUser, password: currentPassC.text);
          // update password
          await auth.currentUser!.updatePassword(newPassC.text);

          Get.back();
          CustomToast.successToast('Sukses', 'Kata sandi berhasil diubah');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            CustomToast.errorToast('Gagal', 'Kata sandi lama salah');
          } else {
            CustomToast.errorToast('Gagal', 'Terjadi kesalahan : ${e.code}');
          }
        } catch (e) {
          CustomToast.errorToast(
              'Gagal', 'Terjadi kesalahan : ${e.toString()}');
        } finally {
          isLoading.value = false;
        }
      } else {
        CustomToast.errorToast('Gagal',
            'Kata sandi baru dan konfirmasi kata sandi baru tidak sama');
      }
    } else {
      CustomToast.errorToast('Gagal', 'Mohon isi semua kolom');
    }
  }
}
