import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/controllers/page_index_controller.dart';
import 'package:hetian_mobile/app/routes/app_pages.dart';
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
            Get.dialog(
              barrierDismissible: false,
              AlertDialog(
                buttonPadding: EdgeInsets.zero,
                actionsPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: const Text('Verifikasi Email'),
                content: const Text(
                    'Email anda belum terverifikasi. Silahkan verifikasi email anda terlebih dahulu'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () async {
                      try {
                        await credential.user!.sendEmailVerification();
                        Get.back();
                        emailC.clear();
                        passC.clear();
                        CustomToast.successToast(
                            "Berhasil", "Email verifikasi telah dikirim");
                        isLoading.value = false;
                      } catch (e) {
                        Get.back();
                        emailC.clear();
                        passC.clear();
                        CustomToast.errorToast("Gagal",
                            "Terjadi kesalahan saat mengirim email verifikasi");
                        isLoading.value = false;
                      }
                    },
                    child: const Text('Kirim Ulang'),
                  ),
                ],
              ),
            );
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          emailC.clear();
          passC.clear();
          CustomToast.errorToast("Gagal", "Akun tidak ditemukan");
        } else if (e.code == 'wrong-password') {
          passC.clear();
          CustomToast.errorToast("Gagal", "Kata sandi salah");
        }
      } catch (e) {
        emailC.clear();
        passC.clear();
        CustomToast.errorToast("Gagal", "Terjadi kesalahan");
        isLoading.value = false;
      }
    } else {
      CustomToast.errorToast(
          "Perhatian", "Email dan kata sandi tidak boleh kosong");
    }
  }
}
