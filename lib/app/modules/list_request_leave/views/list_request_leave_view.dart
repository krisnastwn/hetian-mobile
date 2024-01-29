import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
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
                'Daftar Pengajuan Cuti',
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
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    Map<String, dynamic> leaveData = listLeave[index].data();
                    var leaveId = listLeave[index].id;
                    var employeeId =
                        listLeave[index].reference.parent.parent?.id;

                    bool isManagerApproved =
                        leaveData['manager_approval'] == 'Disetujui' ||
                            leaveData['manager_approval'] == 'Tidak Disetujui';
                    bool isButtonEnabled =
                        userRole != 'HRD' || isManagerApproved;
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: AppColor.secondaryExtraSoft, width: 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: lightColorScheme.primary,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        leaveData['name'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(FontAwesomeIcons.clock,
                                              size: 12, color: Colors.white),
                                          const SizedBox(width: 4),
                                          Text(
                                            DateFormat('d MMMM y', 'id').format(
                                              (leaveData['date_request']
                                                      as Timestamp)
                                                  .toDate(),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Text(
                                    leaveData['role'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Manager',
                                    ),
                                    Text(
                                      leaveData['manager_approval'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'HRD',
                                    ),
                                    Text(
                                      leaveData['hrd_approval'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                              color: AppColor.secondaryExtraSoft,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Dari Tanggal',
                                    ),
                                    Text(
                                      DateFormat('d MMMM y', 'id').format(
                                        (leaveData['start_date'] as Timestamp)
                                            .toDate(),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'Sampai Tanggal',
                                    ),
                                    Text(
                                      DateFormat('d MMMM y', 'id').format(
                                        (leaveData['end_date'] as Timestamp)
                                            .toDate(),
                                      ),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                              color: AppColor.secondaryExtraSoft,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Alasan',
                                ),
                                Text(
                                  leaveData['reason'],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Divider(
                              color: AppColor.secondaryExtraSoft,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: Color.fromRGBO(0, 103, 124, 1),
                                          width: 1),
                                    ),
                                    onPressed: isButtonEnabled
                                        ? () async {
                                            if (employeeId != null) {
                                              controller.rejectLeave(leaveId,
                                                  employeeId, userRole);
                                            }
                                          }
                                        : null,
                                    child: const Text('Tolak'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: FilledButton(
                                    onPressed: isButtonEnabled
                                        ? () {
                                            if (employeeId != null) {
                                              controller.approveLeave(leaveId,
                                                  employeeId, userRole);
                                            }
                                          }
                                        : null,
                                    child: const Text('Terima'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
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
