import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore.collection("employee").doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamHistoryLeave() async* {
    String uid = auth.currentUser!.uid;
    yield* firestore
        .collection("employee")
        .doc(uid)
        .collection("leave")
        .orderBy("date_request", descending: true)
        .limitToLast(12)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamLeaveData() async* {
    String uid = auth.currentUser!.uid;
    String todayDocId =
        DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");
    yield* firestore
        .collection("employee")
        .doc(uid)
        .collection("leave")
        .doc(todayDocId)
        .snapshots();
  }
}
