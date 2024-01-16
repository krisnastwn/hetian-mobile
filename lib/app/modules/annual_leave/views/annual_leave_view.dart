import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/widgets/custom_date_input.dart';
import 'package:hetian_mobile/app/widgets/custom_input.dart';
import 'package:hetian_mobile/color_schemes.dart';
import 'package:intl/intl.dart';

import '../controllers/annual_leave_controller.dart';

class AnnualLeaveView extends GetView<AnnualLeaveController> {
  const AnnualLeaveView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AnnualLeaveController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.primary,
        title: const Text(
          'Pengajuan Cuti',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.done:
              Map<String, dynamic> user = snapshot.data!.data()!;
              controller.nameC.text = user['name'];
              controller.jobC.text = user['job'];

              final DateTime pickedDateRequest = DateTime.now();
              controller.dateRequestC.text =
                  DateFormat('dd-MM-yyyy').format(pickedDateRequest);

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomInput(
                        controller: controller.nameC,
                        label: 'Nama',
                        hint: 'Nama Lengkap',
                        disabled: true,
                        textInputAction: TextInputAction.next,
                      ),
                      CustomInput(
                        controller: controller.jobC,
                        label: 'Jabatan',
                        hint: 'Manager IT',
                        disabled: true,
                        textInputAction: TextInputAction.next,
                      ),
                      CustomDateInput(
                        onTap: null,
                        controller: controller.dateRequestC,
                        disabled: true,
                        width: MediaQuery.of(context).size.width,
                        label: 'Tanggal Pengajuan',
                        hint: '02-01-2024',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomDateInput(
                              onTap: controller.selectStartDate,
                              controller: controller.startDateC,
                              width: MediaQuery.of(context).size.width / 2,
                              label: 'Dari Tanggal',
                              hint: '05-01-2024',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomDateInput(
                              onTap: controller.selectEndDate,
                              controller: controller.endDateC,
                              width: MediaQuery.of(context).size.width / 2,
                              label: 'Sampai Tanggal',
                              hint: '10-01-2024',
                            ),
                          ),
                        ],
                      ),
                      CustomInput(
                        controller: controller.reasonC,
                        label: 'Alasan',
                        hint: 'Alasan Cuti',
                        textInputAction: TextInputAction.done,
                        maxLines: 4,
                      ),
                      Obx(
                        () => SizedBox(
                          height: 50,
                          child: FilledButton(
                            onPressed: () async {
                              if (controller.isLoading.isFalse) {
                                await controller.submitLeaveForm();
                              }
                            },
                            child: Text(
                              (controller.isLoading.isFalse)
                                  ? 'Kirim'
                                  : 'Loading...',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              return const Center(child: Text("Error"));
          }
        },
      ),
    );
  }
}
