import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
import 'package:hetian_mobile/color_schemes.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

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
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 36),
              decoration: BoxDecoration(
                color: lightColorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
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
                          'Atur Ulang Kata Sandi',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Masukkan email yang terdaftar untuk mendapatkan link atur ulang kata sandi.",
                          style: TextStyle(
                            color: AppColor.secondarySoft,
                            height: 150 / 100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: 14, right: 14, top: 4),
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          width: 1, color: AppColor.secondaryExtraSoft),
                    ),
                    child: TextField(
                      style:
                          const TextStyle(fontSize: 14, fontFamily: 'poppins'),
                      maxLines: 1,
                      controller: controller.emailC,
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
                        hintText: "ratnasari@gmail.com",
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                          color: AppColor.secondarySoft,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: FilledButton(
                        onPressed: () async {
                          if (controller.isLoading.isFalse) {
                            await controller.sendEmail();
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
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('ForgotPasswordView'),
    //     centerTitle: true,
    //   ),
    //   body: ListView(
    //     shrinkWrap: true,
    //     padding: EdgeInsets.all(16),
    //     children: [
    //       TextField(
    //         controller: controller.emailC,
    //         autocorrect: false,
    //         decoration: InputDecoration(
    //           border: OutlineInputBorder(),
    //           labelText: 'Email',
    //         ),
    //       ),
    //       Obx(
    //         () => ElevatedButton(
    //           onPressed: () async {
    //             if (controller.isLoading.isFalse) {
    //               await controller.sendEmail();
    //             }
    //           },
    //           child: Text(controller.isLoading.isFalse ? 'Send Reset Password Link' : "Loading..."),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
