import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
import 'package:hetian_mobile/color_schemes.dart';
import 'package:intl/intl.dart';

import '../controllers/leave_controller.dart';

class LeaveView extends GetView<LeaveController> {
  final String employeeId;

  const LeaveView({super.key, required this.employeeId});
  @override
  Widget build(BuildContext context) {
    final String employeeId = Get.arguments;
    controller.fetchLeaves(employeeId);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Cuti Karyawan',
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
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromRGBO(0, 103, 124, 1),
              ),
            );
          } else if (controller.leaves.isEmpty) {
            return const Center(
              child: Text('Tidak ada data cuti'),
            );
          } else {
            return ListView.builder(
              itemCount: controller.leaves.length,
              itemBuilder: (context, index) {
                var leave = controller.leaves[index];
                String hrdApproval = leave.hrdApproval;
                String cancelStatus = leave.cancelStatus;
                Color containerColor;
                if (hrdApproval == "Disetujui" &&
                    cancelStatus == "Belum Dibatalkan") {
                  containerColor = lightColorScheme.secondaryContainer;
                } else if (hrdApproval == "Disetujui" &&
                    cancelStatus == "Dibatalkan") {
                  containerColor = const Color(0xFFFFD1DB);
                } else if (hrdApproval == "Belum Disetujui") {
                  containerColor = Colors.white;
                } else if (hrdApproval == "Tidak Disetujui") {
                  containerColor = const Color(0xFFFFD1DB);
                } else if (hrdApproval == "Disetujui") {
                  containerColor = const Color(0xFFFFD1DB);
                } else {
                  containerColor = Colors.white;
                }
                return SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColor.secondaryExtraSoft, width: 1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tanggal Pengajuan',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          DateFormat('d MMMM y', 'id')
                              .format(DateTime.parse(leave.requestDate)),
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
                          leave.cancelStatus == 'Dibatalkan'
                              ? 'Dibatalkan'
                              : hrdApproval,
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
                          DateFormat('d MMMM y', 'id')
                              .format(DateTime.parse(leave.startDate)),
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
                          DateFormat('d MMMM y', 'id')
                              .format(DateTime.parse(leave.endDate)),
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
                          (leave.reason),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
