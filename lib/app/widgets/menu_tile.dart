import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hetian_mobile/app/style/app_color.dart';
import 'package:hetian_mobile/color_schemes.dart';

class MenuTile extends StatelessWidget {
  final String title;
  final Widget icon;
  final void Function() onTap;
  final bool isDanger;
  const MenuTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              margin: const EdgeInsets.only(right: 24),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.primaryExtraSoft,
                borderRadius: BorderRadius.circular(100),
              ),
              child: icon,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: (isDanger == false)
                      ? lightColorScheme.primary
                      : AppColor.error,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 24),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                    (isDanger == false)
                        ? lightColorScheme.primary
                        : AppColor.error,
                    BlendMode.srcIn),
                child: SvgPicture.asset(
                  'assets/icons/arrow-right.svg',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
