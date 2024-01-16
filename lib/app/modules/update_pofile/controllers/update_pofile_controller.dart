import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/widgets/toast/custom_toast.dart';

class UpdatePofileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController employeeidC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();
  XFile? image;

  Future<void> updateProfile() async {
    String uid = auth.currentUser!.uid;
    if (employeeidC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          "name": nameC.text,
          "email": emailC.text,
        };
        if (image != null) {
          // upload avatar image to storage
          File file = File(image!.path);
          String ext = image!.name.split(".").last;
          String upDir = "$uid/avatar.$ext";
          await storage.ref(upDir).putFile(file);
          String avatarUrl = await storage.ref(upDir).getDownloadURL();

          data.addAll({"avatar": avatarUrl});
        }
        await firestore.collection("employee").doc(uid).update(data);
        image = null;
        Get.back();
        CustomToast.successToast('Sukses', 'Berhasil Perbarui Profil');
      } catch (e) {
        CustomToast.errorToast(
            'Gagal', 'Gagal Perbarui Profil. Karena ${e.toString()}');
      } finally {
        isLoading.value = false;
      }
    } else {
      CustomToast.errorToast('Gagal', 'Semua data harus diisi');
    }
  }

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // print(image!.path);
      // print(image!.name.split(".").last);
    }
    update();
  }

  void deleteProfile() async {
    String uid = auth.currentUser!.uid;
    try {
      await firestore.collection("employee").doc(uid).update({
        "avatar": FieldValue.delete(),
      });
      Get.back();

      Get.snackbar("Berhasil", "Berhasil menghapus avatar profil");
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan",
          "Tidak dapat menghapus avatar profil. Karena ${e.toString()}");
    } finally {
      update();
    }
  }
}
