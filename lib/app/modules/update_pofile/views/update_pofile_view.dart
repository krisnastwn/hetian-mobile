import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
import 'package:hetian_mobile/app/widgets/custom_input.dart';
import 'package:hetian_mobile/color_schemes.dart';

import '../controllers/update_pofile_controller.dart';

class UpdatePofileView extends GetView<UpdatePofileController> {
  final Map<String, dynamic> user = Get.arguments;

  UpdatePofileView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.employeeidC.text = user["employee_id"];
    controller.nameC.text = user["name"];
    controller.emailC.text = user["email"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.primary,
        title: const Text(
          'Perbarui Profil',
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
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          // section 1 - Profile Picture
          Center(
            child: Stack(
              children: [
                GetBuilder<UpdatePofileController>(
                  builder: (controller) {
                    if (controller.image != null) {
                      return ClipOval(
                        child: Container(
                          width: 98,
                          height: 98,
                          color: AppColor.primaryExtraSoft,
                          child: Image.file(
                            File(controller.image!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return ClipOval(
                        child: Container(
                          width: 98,
                          height: 98,
                          color: AppColor.primaryExtraSoft,
                          child: CachedNetworkImage(
                              imageUrl: (user["avatar"] == null ||
                                      user['avatar'] == "")
                                  ? "https://ui-avatars.com/api/?name=${user['name']}/"
                                  : user['avatar'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const SizedBox(),
                              errorWidget: (context, url, error) => const Icon(
                                    Icons.error,
                                  )),
                        ),
                      );
                    }
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.pickImage();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lightColorScheme.primary,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: SvgPicture.asset('assets/icons/camera.svg'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //section 2 - user data
          CustomInput(
            controller: controller.employeeidC,
            label: "ID Karyawan",
            hint: "12345678",
            disabled: true,
            margin: const EdgeInsets.only(bottom: 16, top: 42),
            textInputAction: TextInputAction.next,
          ),
          CustomInput(
            controller: controller.nameC,
            label: "Nama Lengkap",
            hint: "Rika Ratnasari",
            textInputAction: TextInputAction.next,
            focusNode: controller.nameFocusNode,
            onSubmitted: (value) {
              controller.nameFocusNode.unfocus();
              FocusScope.of(context).requestFocus(controller.emailFocusNode);
            },
          ),
          CustomInput(
            controller: controller.emailC,
            label: "Email",
            hint: "ratnasari@gmail.com",
            textInputAction: TextInputAction.done,
            focusNode: controller.emailFocusNode,
            // disabled: true,
          ),
          Obx(
            () => SizedBox(
              height: 50,
              child: FilledButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.updateProfile();
                  }
                },
                child: Text(
                  (controller.isLoading.isFalse) ? 'Perbarui' : 'Loading...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
