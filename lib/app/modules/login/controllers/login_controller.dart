import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/controllers/page_index_controller.dart';
import 'package:hetian_mobile/app/routes/app_pages.dart';
import 'package:hetian_mobile/app/widgets/dialog/custom_alert_dialog.dart';
import 'package:hetian_mobile/app/widgets/toast/custom_toast.dart';

class LoginController extends GetxController {
  final pageIndexController = Get.find<PageIndexController>();
  RxBool isLoading = false.obs;
  RxBool obsecureText = true.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        final credential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        if (credential.user != null) {
          if (credential.user!.emailVerified) {
            isLoading.value = false;
            if (passC.text == 'qwertyuiop') {
              Get.toNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.CUSTOM_SALOMON_NAVBAR);
            }
          } else {
            CustomAlertDialog.showPresenceAlert(
              title: "Verifikasi Email",
              message:
                  "Email anda belum terverifikasi. Silahkan verifikasi email anda terlebih dahulu",
              onCancel: () => Get.back(),
              onConfirm: () async {
                try {
                  await credential.user!.sendEmailVerification();
                  Get.back();
                  CustomToast.successToast(
                      "Berhasil", "Email verifikasi telah dikirim");
                  isLoading.value = false;
                } catch (e) {
                  CustomToast.errorToast("Gagal",
                      "Terjadi kesalahan saat mengirim email verifikasi");
                  isLoading.value = false;
                }
              },
            );
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          CustomToast.errorToast("Gagal", "Akun tidak ditemukan");
        } else if (e.code == 'wrong-password') {
          CustomToast.errorToast("Gagal", "Kata sandi salah");
        }
      } catch (e) {
        CustomToast.errorToast("Gagal", "Terjadi kesalahan");
        isLoading.value = false;
      }
    } else {
      CustomToast.errorToast(
          "Perhatian", "Email dan kata sandi tidak boleh kosong");
    }
  }
}
