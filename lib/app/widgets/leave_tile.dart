import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/routes/app_pages.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
import 'package:hetian_mobile/color_schemes.dart';
import 'package:intl/intl.dart';

class LeaveTile extends StatelessWidget {
  final Map<String, dynamic> leaveData;
  const LeaveTile({super.key, required this.leaveData});

  @override
  Widget build(BuildContext context) {
    String managerApproval = leaveData["manager_approval"] ?? "Belum Disetujui";
    String hrdApproval = leaveData["hrd_approval"] ?? "Belum Disetujui";

    Color containerColor;

    if (managerApproval == "Disetujui" && hrdApproval == "Disetujui") {
      containerColor = lightColorScheme.secondaryContainer;
    } else if (managerApproval == "Belum Disetujui" ||
        hrdApproval == "Belum Disetujui") {
      containerColor = Colors.white;
    } else if (managerApproval == "Tidak Disetujui" ||
        hrdApproval == "Tidak Disetujui") {
      containerColor = const Color(0xFFFFD1DB);
    } else if (managerApproval == "Disetujui" ||
        hrdApproval == "Tidak Disetujui") {
      containerColor = const Color(0xFFFFD1DB);
    } else {
      containerColor = Colors.white;
    }

    return InkWell(
      onTap: () => Get.toNamed(Routes.DETAIL_LEAVE, arguments: leaveData),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 1,
            color: AppColor.primaryExtraSoft,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tanggal Pengajuan",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  DateFormat('d MMMM y', 'id').format(
                      (leaveData["date_request"] as Timestamp).toDate()),
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
                  "Status",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  (hrdApproval),
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
    );
  }
}
