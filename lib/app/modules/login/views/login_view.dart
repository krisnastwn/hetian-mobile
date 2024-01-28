import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/routes/app_pages.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
import 'package:hetian_mobile/color_schemes.dart';
import 'package:flutter/services.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: lightColorScheme.primary,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return OrientationBuilder(builder: (context, orietation) {
      double containerHeight = MediaQuery.of(context).size.height * 0.35;
      double containerWidth = MediaQuery.of(context).size.width;
      if (orietation == Orientation.landscape) {
        containerHeight = MediaQuery.of(context).size.height * 0.5;
        containerWidth = MediaQuery.of(context).size.width;
      }

      return Scaffold(
        backgroundColor: lightColorScheme.primary,
        body: SingleChildScrollView(
          physics: (orietation == Orientation.portrait)
              ? const NeverScrollableScrollPhysics()
              : null,
          child: Column(
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
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: lightColorScheme.background,
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
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF00677C),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          const EdgeInsets.only(left: 14, right: 14, top: 4),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          width: 1,
                          color: AppColor.secondaryExtraSoft,
                        ),
                      ),
                      child: TextField(
                        style: const TextStyle(
                            fontSize: 14, fontFamily: 'poppins'),
                        maxLines: 1,
                        controller: controller.emailC,
                        textInputAction: TextInputAction.next,
                        focusNode: controller.emailFocusNode,
                        onSubmitted: (value) {
                          controller.emailFocusNode.unfocus();
                          FocusScope.of(context)
                              .requestFocus(controller.passFocusNode);
                        },
                        decoration: InputDecoration(
                          label: Text(
                            "Email",
                            style: TextStyle(
                              color: AppColor.secondarySoft,
                              fontSize: 14,
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: InputBorder.none,
                          hintText: "youremail@hetian.com",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                            color: AppColor.secondarySoft,
                          ),
                        ),
                      ),
                    ),
                    Material(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding:
                            const EdgeInsets.only(left: 14, right: 14, top: 4),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 1,
                            color: AppColor.secondaryExtraSoft,
                          ),
                        ),
                        child: Obx(
                          () => TextField(
                            style: const TextStyle(
                                fontSize: 14, fontFamily: 'poppins'),
                            maxLines: 1,
                            controller: controller.passC,
                            obscureText: controller.obsecureText.value,
                            textInputAction: TextInputAction.done,
                            focusNode: controller.passFocusNode,
                            decoration: InputDecoration(
                              label: Text(
                                "Kata sandi",
                                style: TextStyle(
                                  color: AppColor.secondarySoft,
                                  fontSize: 14,
                                ),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: InputBorder.none,
                              hintText: "*************",
                              suffixIcon: IconButton(
                                icon: (controller.obsecureText.isFalse)
                                    ? SvgPicture.asset('assets/icons/show.svg')
                                    : SvgPicture.asset('assets/icons/hide.svg'),
                                onPressed: () {
                                  controller.obsecureText.value =
                                      !(controller.obsecureText.value);
                                },
                              ),
                              hintStyle: TextStyle(
                                fontSize: 14,
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w500,
                                color: AppColor.secondarySoft,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(
                      () => SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: FilledButton(
                          onPressed: () async {
                            if (controller.isLoading.isFalse) {
                              await controller.login();
                            }
                          },
                          child: Text(
                            (controller.isLoading.isFalse)
                                ? 'Masuk'
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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 4),
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                        child: const Text("Lupa kata sandi?"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
