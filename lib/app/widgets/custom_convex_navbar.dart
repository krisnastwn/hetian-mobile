// import 'package:convex_bottom_bar/convex_bottom_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import 'package:get/get.dart';
// import 'package:hetian_mobile/app/controllers/page_index_controller.dart';
// import 'package:hetian_mobile/app/modules/home/controllers/home_controller.dart';
// import 'package:hetian_mobile/color_schemes.dart';

// class CustomConvexNavbarView extends GetView<PageIndexController> {
//   const CustomConvexNavbarView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     Get.put(HomeController(), permanent: true);
//     return ConvexAppBar(
//       height: 55,
//       activeColor: lightColorScheme.primary,
//       color: lightColorScheme.primary,
//       style: TabStyle.fixedCircle,
//       items: [
//         TabItem(
//           icon: (controller.pageIndex.value == 0)
//               ? SvgPicture.asset('assets/icons/home-active.svg')
//               : SvgPicture.asset('assets/icons/home.svg'),
//           // title: 'Home',
//         ),
//         TabItem(
//           icon: Obx(
//             () {
//               if (controller.presenceController.isLoading.isFalse) {
//                 return Transform.scale(
//                   scale: 0.7,
//                   child: ColorFiltered(
//                     colorFilter:
//                         const ColorFilter.mode(Colors.white, BlendMode.srcIn),
//                     child: Image.asset(
//                       'assets/icons/sign-out-line.png',
//                     ),
//                   ),
//                 );
//               } else {
//                 return const Center(
//                   child: CircularProgressIndicator(color: Colors.white),
//                 );
//               }
//             },
//           ),
//         ),
//         TabItem(
//           icon: (controller.currentIndex.value == 2)
//               ? SvgPicture.asset('assets/icons/profile-active.svg')
//               : SvgPicture.asset('assets/icons/profile.svg'),
//           // title: 'Profile',
//         ),
//       ],
//       initialActiveIndex: controller.currentIndex.value,
//       onTap: (int i) => controller.changePage(i),
//       backgroundColor: lightColorScheme.secondaryContainer,
//       elevation: 0,
//     );
//   }
// }
