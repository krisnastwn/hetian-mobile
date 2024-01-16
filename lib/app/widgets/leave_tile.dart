import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/routes/app_pages.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
import 'package:hetian_mobile/color_schemes.dart';

class LeaveTile extends StatelessWidget {
  final Map<String, dynamic> leaveData;
  const LeaveTile({super.key, required this.leaveData});

  @override
  Widget build(BuildContext context) {
    String status = leaveData["status"];
    Color containerColor;

    switch (status) {
      case "Disetujui":
        containerColor = lightColorScheme.secondaryContainer;
        break;
      case "Belum Disetujui":
        containerColor = Colors.white;
        break;
      case "Tidak Disetujui":
        containerColor = const Color(0xFFFFD1DB);
        break;
      default:
        containerColor = Colors.white;
        break;
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
                  (leaveData["date_request"] ?? "-"),
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
                  (leaveData["status"] ?? "-"),
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
