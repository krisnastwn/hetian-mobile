import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
import 'package:hetian_mobile/app/widgets/request_leave_card.dart';
import 'package:hetian_mobile/color_schemes.dart';
import 'package:intl/intl.dart';
import '../controllers/list_request_leave_controller.dart';

class ListRequestLeaveView extends GetView<ListRequestLeaveController> {
  const ListRequestLeaveView({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('employee')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          String? userRole = snapshot.data?.data()?['role'];
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Daftar Pengajuan & Pembatalan Cuti',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: ColorFiltered(
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  child: SvgPicture.asset(
                    'assets/icons/arrow-left.svg',
                  ),
                ),
              ),
              backgroundColor: lightColorScheme.primary,
              elevation: 0,
              centerTitle: true,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(1),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: AppColor.secondaryExtraSoft,
                ),
              ),
            ),
            body: StreamBuilder<QuerySnapshot<Object?>>(
              stream: controller.streamLeaveRequest(userRole!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('Tidak ada data pengajuan cuti'));
                }

                List<QueryDocumentSnapshot<Map<String, dynamic>>> listLeave =
                    snapshot.data!.docs
                        .map((doc) =>
                            doc as QueryDocumentSnapshot<Map<String, dynamic>>)
                        .toList();

                return ListView.separated(
                  itemCount: listLeave.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 0),
                  itemBuilder: (context, index) {
                    Map<String, dynamic> leaveData = listLeave[index].data();
                    var leaveId = listLeave[index].id;
                    var employeeId =
                        listLeave[index].reference.parent.parent?.id;
                    bool isManagerApproved =
                        leaveData['manager_approval'] == 'Disetujui';
                    bool isManagerRejected =
                        leaveData['manager_approval'] == 'Tidak Disetujui';
                    bool isNewRequest = leaveData['manager_approval'] == 'Belum Disetujui' &&
                        leaveData['hrd_approval'] == 'Belum Disetujui';
                    bool isApproveButtonEnabled =
                        (userRole == 'Manager' && isNewRequest) ||
                            (userRole == 'HRD' && isManagerApproved);
                    bool isRejectButtonEnabled =
                        (userRole == 'Manager' && isNewRequest) ||
                            (userRole == 'HRD' && isManagerRejected);

                    if (leaveData['cancel_status'] == 'Dibatalkan') {
                      return RequestLeaveCard(
                        color: const Color.fromRGBO(223, 27, 27, 1),
                        name: leaveData['name'],
                        dateRequest: DateFormat('d MMMM y', 'id').format(
                          (leaveData['date_request'] as Timestamp).toDate(),
                        ),
                        role: leaveData['role'],
                        startDate: DateFormat('d MMMM y', 'id').format(
                          (leaveData['start_date'] as Timestamp).toDate(),
                        ),
                        endDate: DateFormat('d MMMM y', 'id').format(
                          (leaveData['end_date'] as Timestamp).toDate(),
                        ),
                        managerApproval: leaveData['manager_approval'],
                        hrdApproval: leaveData['hrd_approval'],
                        reason: leaveData['reason'],
                        title: 'Status Pembatalan Cuti',
                        onReject: isRejectButtonEnabled
                            ? () async {
                                if (employeeId != null) {
                                  controller.rejectLeave(
                                      leaveId, employeeId, userRole);
                                }
                              }
                            : null,
                        onApprove: isApproveButtonEnabled
                            ? () {
                                if (employeeId != null) {
                                  controller.approveLeave(
                                      leaveId, employeeId, userRole);
                                }
                              }
                            : null,
                      );
                    } else if (leaveData['cancel_status'] ==
                        'Belum Dibatalkan') {
                      return RequestLeaveCard(
                        color: lightColorScheme.primary,
                        name: leaveData['name'],
                        dateRequest: DateFormat('d MMMM y', 'id').format(
                          (leaveData['date_request'] as Timestamp).toDate(),
                        ),
                        role: leaveData['role'],
                        startDate: DateFormat('d MMMM y', 'id').format(
                          (leaveData['start_date'] as Timestamp).toDate(),
                        ),
                        endDate: DateFormat('d MMMM y', 'id').format(
                          (leaveData['end_date'] as Timestamp).toDate(),
                        ),
                        managerApproval: leaveData['manager_approval'],
                        hrdApproval: leaveData['hrd_approval'],
                        reason: leaveData['reason'],
                        title: 'Status Pengajuan Cuti',
                        onReject: isRejectButtonEnabled
                            ? () async {
                                if (employeeId != null) {
                                  controller.rejectLeave(
                                      leaveId, employeeId, userRole);
                                }
                              }
                            : null,
                        onApprove: isApproveButtonEnabled
                            ? () {
                                if (employeeId != null) {
                                  controller.approveLeave(
                                      leaveId, employeeId, userRole);
                                }
                              }
                            : null,
                      );
                    }
                    return const SizedBox();
                  },
                );
              },
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(0, 103, 124, 1),
          ),
        );
      },
    );
  }
}
