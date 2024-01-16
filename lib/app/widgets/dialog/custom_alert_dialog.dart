import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
import 'package:hetian_mobile/color_schemes.dart';

class CustomAlertDialog {
  static confirmAdmin({
    required String title,
    required String message,
    required void Function() onConfirm,
    required void Function() onCancel,
    required TextEditingController controller,
  }) {
    Get.defaultDialog(
      backgroundColor: lightColorScheme.background,
      title: "",
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      radius: 8,
      titlePadding: EdgeInsets.zero,
      titleStyle: const TextStyle(fontSize: 0),
      content: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              textInputAction: TextInputAction.done,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Masukkan kata sandi',
                hintStyle: TextStyle(
                  color: AppColor.secondarySoft,
                  fontSize: 14,
                  fontFamily: 'poppins',
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: OutlinedButton(
                  onPressed: onCancel,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: lightColorScheme.primary),
                  ),
                  child: Text(
                    "Batal",
                    style: TextStyle(color: lightColorScheme.primary),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 6,
                child: FilledButton(
                  onPressed: onConfirm,
                  child: const Text("Kirim"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  static showPresenceAlert({
    required String title,
    required String message,
    required void Function() onConfirm,
    required void Function() onCancel,
  }) {
    Get.defaultDialog(
      backgroundColor: lightColorScheme.background,
      title: "",
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      radius: 16,
      titlePadding: EdgeInsets.zero,
      titleStyle: const TextStyle(fontSize: 0),
      content: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 24, top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(
                    color: AppColor.secondarySoft,
                    height: 150 / 100,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 6,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      backgroundColor: lightColorScheme.background,
                      side: BorderSide(color: lightColorScheme.primary)),
                  onPressed: onCancel,
                  child: const Text(
                    "Cancel",
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 6,
                child: FilledButton(
                  onPressed: onConfirm,
                  child: const Text("Confirm"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
