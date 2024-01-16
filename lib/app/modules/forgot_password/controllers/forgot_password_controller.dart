import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/widgets/toast/custom_toast.dart';

class ForgotPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> sendEmail() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        auth.sendPasswordResetEmail(email: emailC.text);
        Get.back();
        CustomToast.successToast("Sukses",
            "Link untuk atur ulang kata sandi telah dikirim ke email anda");
      } catch (e) {
        CustomToast.errorToast("Gagal",
            "Gagal mengirim link untuk atur ulang kata sandi. Karena ${e.toString()}");
      } finally {
        isLoading.value = false;
      }
    } else {
      CustomToast.errorToast("Gagal", "Email harus diisi");
    }
  }
}
