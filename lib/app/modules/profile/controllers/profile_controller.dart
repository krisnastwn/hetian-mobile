import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/modules/navigation_bar/controllers/navigation_bar_controller.dart';
import 'package:hetian_mobile/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("employee").doc(uid).snapshots();
  }

  void logout() async {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah anda yakin ingin keluar?'),
        buttonPadding: EdgeInsets.zero,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: const Text('Keluar'),
            onPressed: () async {
              // Show the loading indicator
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
              await auth.signOut();
              Get.back(); // Close the dialog
              // Get the NavigationBarController
              NavigationBarController navController =
                  Get.find<NavigationBarController>();

              // Reset the selected index to 0
              navController.selectedIndex.value = 0;

              // Navigate to the login screen
              Get.offAllNamed(Routes.LOGIN);
            },
          ),
        ],
      ),
    );
  }
}
