import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/controllers/page_index_controller.dart';
import 'package:hetian_mobile/app/routes/app_pages.dart';
import 'package:hetian_mobile/app/widgets/toast/custom_toast.dart';
import 'package:hetian_mobile/company_data.dart';

class NewPasswordController extends GetxController {
  final pageIndexController = Get.find<PageIndexController>();
  RxBool isLoading = false.obs;
  RxBool newPassObs = true.obs;
  RxBool newPassCObs = true.obs;
  TextEditingController passC = TextEditingController();
  TextEditingController confirmPassC = TextEditingController();
  FocusNode passFocusNode = FocusNode();
  FocusNode confirmPassFocusNode = FocusNode();

  FirebaseAuth auth = FirebaseAuth.instance;

  void newPassword() async {
    if (passC.text.isNotEmpty && confirmPassC.text.isNotEmpty) {
      if (passC.text == confirmPassC.text) {
        isLoading.value = true;
        if (passC.text != CompanyData.defaultPassword) {
          await _updatePassword();
          isLoading.value = false;
        } else {
          CustomToast.errorToast('Gagal', 'Kata sandi tidak boleh sama');
          isLoading.value = false;
        }
      } else {
        CustomToast.errorToast('Gagal', 'Kata sandi tidak sama');
      }
    } else {
      CustomToast.errorToast('Gagal', 'Kata sandi harus diisi');
    }
  }

  Future<void> _updatePassword() async {
    try {
      String email = auth.currentUser!.email!;
      await auth.currentUser!.updatePassword(passC.text);
      // relogin
      await auth.signOut();
      await auth.signInWithEmailAndPassword(email: email, password: passC.text);
      Get.offAllNamed(Routes.CUSTOM_SALOMON_NAVBAR);

      // pageIndexController.changePage(0);
      CustomToast.successToast('Sukses', 'Kata sandi berhasil diubah');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        CustomToast.errorToast(
            'Gagal', 'Kata sandi terlalu lemah, minimal 6 karakter');
      }
    } catch (e) {
      CustomToast.errorToast('Gagal', 'Error : ${e.toString()}');
    }
  }
}
