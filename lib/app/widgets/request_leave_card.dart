import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hetian_mobile/app/style/app_color.dart';

class RequestLeaveCard extends StatelessWidget {
  final String? name;
  final String? dateRequest;
  final String? role;
  final String? startDate;
  final String? endDate;
  final String? managerApproval;
  final String? hrdApproval;
  final String? reason;
  final String? title;
  final Function? onApprove;
  final Function? onReject;
  final Color? color;

  const RequestLeaveCard(
      {super.key,
      this.name,
      this.dateRequest,
      this.role,
      this.startDate,
      this.endDate,
      this.managerApproval,
      this.hrdApproval,
      this.reason,
      this.title,
      this.color,
      required this.onApprove,
      required this.onReject});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.secondaryExtraSoft, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color!,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name!,
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
                          Text(
                            dateRequest!,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Text(
                    role!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: Text(
              title!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dari Tanggal',
                    ),
                    Text(
                      startDate!,
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
                      'Sampai Tanggal',
                    ),
                    Text(
                      endDate!,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              color: AppColor.secondaryExtraSoft,
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Manager',
                    ),
                    Text(
                      managerApproval!,
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
                      'HRD',
                    ),
                    Text(
                      hrdApproval!,
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
                  'Alasan',
                ),
                Text(
                  reason!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
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
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color.fromRGBO(0, 103, 124, 1), width: 1),
                    ),
                    onPressed: onReject != null ? () => onReject!() : null,
                    child: const Text('Tolak'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: onApprove != null ? () => onApprove!() : null,
                    child: const Text('Terima'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
