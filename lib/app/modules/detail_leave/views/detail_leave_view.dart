import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
import 'package:hetian_mobile/app/widgets/custom_date_input.dart';
import 'package:hetian_mobile/app/widgets/custom_input.dart';
import 'package:hetian_mobile/color_schemes.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_leave_controller.dart';

class DetailLeaveView extends GetView<DetailLeaveController> {
  DetailLeaveView({super.key});

  final Map<String, dynamic> leaveData = Get.arguments;

  @override
  Widget build(BuildContext context) {
    var style = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
    controller.startDateC = TextEditingController(
      text: leaveData["start_date"] != null
          ? DateFormat('dd-MM-yyyy')
              .format((leaveData["start_date"] as Timestamp).toDate())
          : "",
    );

    controller.endDateC = TextEditingController(
      text: leaveData["end_date"] != null
          ? DateFormat('dd-MM-yyyy')
              .format((leaveData["end_date"] as Timestamp).toDate())
          : "",
    );
    controller.leaveData.assignAll(leaveData);
    String managerApproval = leaveData["manager_approval"];
    String hrdApproval = leaveData["hrd_approval"];
    String cancelStatus = leaveData["cancel_status"];

    Color containerColor;

    if (managerApproval == "Disetujui" &&
        hrdApproval == "Disetujui" &&
        cancelStatus == "Belum Dibatalkan") {
      containerColor = lightColorScheme.primary;
    } else if (managerApproval == "Disetujui" &&
        hrdApproval == "Disetujui" &&
        cancelStatus == "Dibatalkan") {
      containerColor = const Color.fromRGBO(223, 27, 27, 1);
    } else if (managerApproval == "Belum Disetujui" ||
        hrdApproval == "Belum Disetujui") {
      containerColor = lightColorScheme.primary;
    } else if (managerApproval == "Disetujui" ||
        hrdApproval == "Tidak Disetujui") {
      containerColor = const Color.fromRGBO(223, 27, 27, 1);
    } else if (managerApproval == "Tidak Disetujui" ||
        hrdApproval == "Tidak Disetujui") {
      containerColor = const Color.fromRGBO(223, 27, 27, 1);
    } else {
      containerColor = lightColorScheme.primary;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Cuti',
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: AppColor.secondaryExtraSoft, width: 1),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (leaveData["name"] ?? "-"),
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
                                  Obx(
                                    () => Text(
                                      DateFormat('d MMMM y', 'id').format(
                                          (controller.leaveData["date_request"]
                                                  as Timestamp)
                                              .toDate()),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              leaveData["cancel_status"] == "Dibatalkan"
                                  ? leaveData["cancel_status"]
                                  : leaveData["hrd_approval"],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Dari Tanggal'),
                            Obx(
                              () => Text(
                                controller.leaveData["start_date"] != null
                                    ? DateFormat('d MMMM y', 'id').format(
                                        (controller.leaveData["start_date"]
                                                as Timestamp)
                                            .toDate())
                                    : "-",
                                style: style,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Sampai Tanggal'),
                            Obx(
                              () => Text(
                                controller.leaveData["end_date"] != null
                                    ? DateFormat('d MMMM y', 'id').format(
                                        (controller.leaveData["end_date"]
                                                as Timestamp)
                                            .toDate())
                                    : "-",
                                style: style,
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
                          'Status Pengajuan Cuti',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Manager'),
                                Obx(
                                  () => Text(
                                    controller.leaveData["manager_approval"],
                                    style: style,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('HRD'),
                                Obx(
                                  () => Text(
                                    controller.leaveData["hrd_approval"],
                                    style: style,
                                  ),
                                ),
                              ],
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
                        const Text('Alasan'),
                        Obx(() => Text((controller.leaveData["reason"] ?? "-"),
                            style: style)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  leaveData["hrd_approval"] == "Dibatalkan" ||
                          leaveData["hrd_approval"] == "Tidak Disetujui"
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(
                            color: AppColor.secondaryExtraSoft,
                            thickness: 1,
                          ),
                        ),
                  leaveData["hrd_approval"] == "Dibatalkan" ||
                          leaveData["hrd_approval"] == "Tidak Disetujui"
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    controller.toggleEdit();
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Color.fromRGBO(0, 103, 124, 1),
                                        width: 1),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.edit, size: 16),
                                      SizedBox(width: 8),
                                      Text('Ubah'),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: FilledButton(
                                  onPressed: () {
                                    controller.cancelLeaveRequest(
                                        leaveData["doc_id"]);
                                  },
                                  style: FilledButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(223, 27, 27, 1),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cancel, size: 16),
                                      SizedBox(width: 8),
                                      Text('Batalkan'),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Obx(
              () {
                if (controller.isEditing.value) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('Ubah Cuti', style: style),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomDateInput(
                                onTap: () {
                                  controller.selectStartDate();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                controller: controller.startDateC,
                                width: Get.size.width / 2,
                                label: 'Dari Tanggal',
                                hint: '',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomDateInput(
                                onTap: () {
                                  controller.selectEndDate();
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
                                },
                                controller: controller.endDateC,
                                width: Get.size.width / 2,
                                label: 'Sampai Tanggal',
                                hint: '',
                              ),
                            ),
                          ],
                        ),
                        CustomInput(
                          controller: controller.reasonC,
                          label: 'Alasan',
                          hint: '',
                          textInputAction: TextInputAction.done,
                          maxLines: 4,
                        ),
                        SizedBox(
                          height: 50,
                          child: FilledButton(
                              onPressed: () {
                                print(leaveData["doc_id"]);
                                print('pressed');
                                controller
                                    .editLeaveRequest(
                                  leaveData["doc_id"],
                                  controller.startDateC.text,
                                  controller.endDateC.text,
                                  controller.reasonC.text,
                                )
                                    .then((updatedLeaveData) {
                                  // Update leaveData with the updated data
                                  leaveData
                                    ..["start_date"] =
                                        updatedLeaveData["start_date"]
                                    ..["end_date"] =
                                        updatedLeaveData["end_date"]
                                    ..["reason"] = updatedLeaveData["reason"];

                                  // Notify GetX to rebuild the widgets
                                  controller.update();
                                });
                              },
                              child: const Text('Kirim')),
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox(); // return an empty container when not editing
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
