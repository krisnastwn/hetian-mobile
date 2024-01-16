import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
import 'package:hetian_mobile/color_schemes.dart';
import '../controllers/list_request_leave_controller.dart';

class ListRequestLeaveView extends GetView<ListRequestLeaveController> {
  const ListRequestLeaveView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Pengajuan Cuti',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamLeaveRequest(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Tidak ada data pengajuan cuti'));
          }
          List<QueryDocumentSnapshot<Map<String, dynamic>>> listLeave =
              snapshot.data!.docs;
          return ListView.separated(
            itemCount: listLeave.length,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              Map<String, dynamic> leaveData = listLeave[index].data();
              var leaveId = listLeave[index].id;
              var employeeId = listLeave[index].reference.parent.parent?.id;
              return SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(16),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: AppColor.secondaryExtraSoft, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        leaveData['name'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        leaveData['job'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tanggal Pengajuan',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        leaveData['date_request'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        leaveData['status'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Dari Tanggal',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        leaveData['start_date'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Sampai Tanggal',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        leaveData['end_date'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Alasan',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        leaveData['reason'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Color.fromRGBO(0, 103, 124, 1),
                                    width: 1),
                              ),
                              onPressed: () {
                                if (employeeId != null) {
                                  controller.rejectLeave(leaveId, employeeId);
                                }
                              },
                              child: const Text('Tolak'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                if (employeeId != null) {
                                  controller.approveLeave(leaveId, employeeId);
                                }
                              },
                              child: const Text('Terima'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
