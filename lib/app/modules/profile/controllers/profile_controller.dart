import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/routes/app_pages.dart';
import 'package:hetian_mobile/color_schemes.dart';

class ProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("employee").doc(uid).snapshots();
  }

  // void logout() async {
  //   await auth.signOut();
  //   Get.offAllNamed(Routes.LOGIN);
  // }

  void logout() async {
    Get.defaultDialog(
      title: 'Konfirmasi',
      middleText: 'Apakah anda yakin ingin keluar?',
      contentPadding: const EdgeInsets.all(16),
      actions: [
        OutlinedButton(
          onPressed: () {
            Get.back();
          },
          style: OutlinedButton.styleFrom(
            primary: lightColorScheme.primary,
            side: const BorderSide(color: Color.fromRGBO(0, 103, 124, 1)),
          ),
          child: const Text('Kembali'),
        ),
        FilledButton(
            onPressed: () async {
              await auth.signOut();
              Get.offAllNamed(Routes.LOGIN);
            },
            child: const Text('Keluar')),
      ],
    );
  }
}
