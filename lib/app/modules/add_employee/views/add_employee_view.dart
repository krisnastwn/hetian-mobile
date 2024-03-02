import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
import 'package:hetian_mobile/app/widgets/custom_input.dart';
import 'package:hetian_mobile/color_schemes.dart';

import '../controllers/add_employee_controller.dart';

class AddEmployeeView extends GetView<AddEmployeeController> {
  const AddEmployeeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Karyawan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
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
      body: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          CustomInput(
            controller: controller.idC,
            label: 'ID Karyawan',
            hint: '12345678',
            textInputAction: TextInputAction.next,
            focusNode: controller.idFocusNode,
            onSubmitted: (value) {
              controller.idFocusNode.unfocus();
              FocusScope.of(context).requestFocus(controller.nameFocusNode);
            },
          ),
          CustomInput(
            controller: controller.nameC,
            label: 'Nama Lengkap',
            hint: 'Rika Ratnasari',
            textInputAction: TextInputAction.next,
            focusNode: controller.nameFocusNode,
            onSubmitted: (value) {
              controller.nameFocusNode.unfocus();
              FocusScope.of(context).requestFocus(controller.emailFocusNode);
            },
          ),
          CustomInput(
            controller: controller.emailC,
            label: 'Email',
            hint: 'rikaratnasari@hetian.com',
            textInputAction: TextInputAction.next,
            focusNode: controller.emailFocusNode,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(left: 16, right: 16, top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1, color: AppColor.secondaryExtraSoft),
            ),
            child: DropdownButtonFormField(
              value: controller.selectedRole.value,
              decoration: InputDecoration(
                labelText: 'Jabatan',
                labelStyle: TextStyle(
                  color: AppColor.secondarySoft,
                  fontSize: 14,
                ),
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
              ),
              items: controller.roles.map((String role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (String? newValue) {
                controller.selectedRole.value = newValue!;
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Obx(
              () => FilledButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.addEmployee();
                  }
                },
                child: Text(
                  (controller.isLoading.isFalse) ? 'Tambahkan' : 'Loading...',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'poppins',
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
