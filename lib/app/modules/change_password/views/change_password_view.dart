import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
import 'package:hetian_mobile/app/widgets/custom_input.dart';
import 'package:hetian_mobile/color_schemes.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ubah Kata Sandi',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: ColorFiltered(
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              child: SvgPicture.asset('assets/icons/arrow-left.svg')),
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
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          Obx(
            () => CustomInput(
              controller: controller.currentPassC,
              label: 'Kata Sandi Lama',
              hint: '*************',
              obsecureText: controller.oldPassObs.value,
              maxLines: 1,
              textInputAction: TextInputAction.next,
              focusNode: controller.currentPassFocusNode,
              onSubmitted: (value) {
                controller.currentPassFocusNode.unfocus();
                FocusScope.of(context).requestFocus(controller.newPassFocusNode);
              },
              suffixIcon: IconButton(
                icon: (controller.oldPassObs.value != false)
                    ? SvgPicture.asset('assets/icons/show.svg')
                    : SvgPicture.asset('assets/icons/hide.svg'),
                onPressed: () {
                  controller.oldPassObs.value = !(controller.oldPassObs.value);
                },
              ),
            ),
          ),
          Obx(
            () => CustomInput(
              controller: controller.newPassC,
              label: 'Kata Sandi Baru',
              hint: '*************',
              obsecureText: controller.newPassObs.value,
              maxLines: 1,
              textInputAction: TextInputAction.next,
              focusNode: controller.newPassFocusNode,
              onSubmitted: (value) {
                controller.newPassFocusNode.unfocus();
                FocusScope.of(context)
                    .requestFocus(controller.confirmNewPassFocusNode);
              },
              suffixIcon: IconButton(
                icon: (controller.newPassObs.value != false)
                    ? SvgPicture.asset('assets/icons/show.svg')
                    : SvgPicture.asset('assets/icons/hide.svg'),
                onPressed: () {
                  controller.newPassObs.value = !(controller.newPassObs.value);
                },
              ),
            ),
          ),
          Obx(
            () => CustomInput(
              controller: controller.confirmNewPassC,
              label: 'Konfirmasi Kata Sandi',
              hint: '*************',
              obsecureText: controller.newPassCObs.value,
              maxLines: 1,
              textInputAction: TextInputAction.done,
              focusNode: controller.confirmNewPassFocusNode,
              suffixIcon: IconButton(
                icon: (controller.newPassCObs.value != false)
                    ? SvgPicture.asset('assets/icons/show.svg')
                    : SvgPicture.asset('assets/icons/hide.svg'),
                onPressed: () {
                  controller.newPassCObs.value =
                      !(controller.newPassCObs.value);
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Obx(
              () => FilledButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await controller.updatePassword();
                  }
                },
                child: Text(
                  (controller.isLoading.isFalse)
                      ? "Ubah Kata Sandi"
                      : 'Loading...',
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'poppins',
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
