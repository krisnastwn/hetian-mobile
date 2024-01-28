import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
import 'package:hetian_mobile/app/widgets/custom_input.dart';
import 'package:hetian_mobile/color_schemes.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orietation) {
      double containerHeight = MediaQuery.of(context).size.height * 0.23;
      double containerWidth = MediaQuery.of(context).size.width;
      if (orietation == Orientation.landscape) {
        containerHeight = MediaQuery.of(context).size.height * 0.5;
        containerWidth = MediaQuery.of(context).size.width;
      }
      return Scaffold(
        backgroundColor: lightColorScheme.primary,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: ColorFiltered(
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              child: SvgPicture.asset(
                'assets/icons/arrow-left.svg',
              ),
            ),
            onPressed: () => Get.back(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: ListView(
          physics: (orietation == Orientation.portrait)
              ? const NeverScrollableScrollPhysics()
              : null,
          shrinkWrap: true,
          children: [
            Container(
              height: containerHeight,
              width: containerWidth,
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              decoration: BoxDecoration(
                color: lightColorScheme.primary,
              ),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Hetian Enterprises\nMobile App",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontFamily: 'poppins',
                    height: 150 / 100,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: lightColorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kata Sandi Baru',
                          style: TextStyle(
                            color: Color(0xFF00677C),
                            fontSize: 18,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Masukkan kata sandi baru anda",
                          style: TextStyle(
                            color: AppColor.secondarySoft,
                            height: 150 / 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => CustomInput(
                      controller: controller.passC,
                      label: 'Kata Sandi Baru',
                      hint: '*****************',
                      obsecureText: controller.newPassObs.value,
                      maxLines: 1,
                      textInputAction: TextInputAction.next,
                      focusNode: controller.passFocusNode,
                      onSubmitted: (value) {
                        controller.passFocusNode.unfocus();
                        FocusScope.of(context)
                            .requestFocus(controller.confirmPassFocusNode);
                      },
                      suffixIcon: IconButton(
                        icon: (controller.newPassObs.value != false)
                            ? SvgPicture.asset('assets/icons/hide.svg')
                            : SvgPicture.asset('assets/icons/show.svg'),
                        onPressed: () {
                          controller.newPassObs.value =
                              !(controller.newPassObs.value);
                        },
                      ),
                    ),
                  ),
                  Obx(
                    () => CustomInput(
                      controller: controller.confirmPassC,
                      label: 'Konfirmasi Kata Sandi Baru',
                      hint: '*****************',
                      obsecureText: controller.newPassCObs.value,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                      focusNode: controller.confirmPassFocusNode,
                      suffixIcon: IconButton(
                        icon: (controller.newPassCObs.value != false)
                            ? SvgPicture.asset('assets/icons/hide.svg')
                            : SvgPicture.asset('assets/icons/show.svg'),
                        onPressed: () {
                          controller.newPassCObs.value =
                              !(controller.newPassCObs.value);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: FilledButton(
                        onPressed: () {
                          if (controller.isLoading.isFalse) {
                            controller.newPassword();
                          }
                        },
                        child: Text(
                          (controller.isLoading.isFalse)
                              ? 'Kirim'
                              : 'Loading...',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
