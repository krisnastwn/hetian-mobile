import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/routes/app_pages.dart';
import 'package:hetian_mobile/app/widgets/menu_tile.dart';
import 'package:hetian_mobile/color_schemes.dart';
import 'package:flutter/services.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
          statusBarColor: lightColorScheme.primary,
          statusBarIconBrightness: Brightness.light),
    );
    return OrientationBuilder(
      builder: (context, orietation) {
        double containerHeight = MediaQuery.of(context).size.height * 0.25;
        double containerWidth = MediaQuery.of(context).size.width;
        if (orietation == Orientation.landscape) {
          containerHeight = MediaQuery.of(context).size.height * 0.5;
          containerWidth = MediaQuery.of(context).size.width;
        }
        final controller = Get.put(ProfileController());
        return Scaffold(
          backgroundColor: lightColorScheme.primary,
          // extendBody: true,
          body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.active:
                case ConnectionState.done:
                  Map<String, dynamic> userData = snapshot.data!.data()!;
                  return SafeArea(
                    child: SingleChildScrollView(
                      physics: orietation == Orientation.portrait
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          // section 1 - profile
                          Container(
                            width: containerWidth,
                            padding: const EdgeInsets.all(16),
                            color: lightColorScheme.primary,
                            height: containerHeight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    color: Colors.blue,
                                    child: CachedNetworkImage(
                                      imageUrl: (userData["avatar"] == null ||
                                              userData['avatar'] == "")
                                          ? "https://ui-avatars.com/api/?name=${userData['name']}/"
                                          : userData['avatar'],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const SizedBox(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 16, bottom: 4),
                                  child: Text(
                                    userData["name"],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                  userData["job"],
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          // section 2 - menu
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              color: Color(0xFFFBFCFE),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 8),
                                MenuTile(
                                  title: 'Perbarui Profil',
                                  icon: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                        lightColorScheme.primary,
                                        BlendMode.srcIn),
                                    child: SvgPicture.asset(
                                        'assets/icons/profile-1.svg'),
                                  ),
                                  onTap: () => Get.toNamed(Routes.UPDATE_POFILE,
                                      arguments: userData),
                                ),
                                MenuTile(
                                  title: 'Ubah Kata Sandi',
                                  icon: ColorFiltered(
                                    colorFilter: ColorFilter.mode(
                                      lightColorScheme.primary,
                                      BlendMode.srcIn,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/password.svg',
                                    ),
                                  ),
                                  onTap: () =>
                                      Get.toNamed(Routes.CHANGE_PASSWORD),
                                ),
                                (userData["job"] == "HRD")
                                    ? MenuTile(
                                        title: 'Tambah Pegawai',
                                        icon: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                            lightColorScheme.primary,
                                            BlendMode.srcIn,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/icons/people.svg',
                                          ),
                                        ),
                                        onTap: () =>
                                            Get.toNamed(Routes.ADD_EMPLOYEE),
                                      )
                                    : const SizedBox(),
                                (userData["job"] == "HRD")
                                    ? MenuTile(
                                        title: 'Riwayat Cuti Pegawai',
                                        icon: Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.personCircleCheck,
                                            color: lightColorScheme.primary,
                                            size: 20,
                                          ),
                                        ),
                                        onTap: () {
                                          Get.toNamed(
                                            Routes.EMPLOYEE,
                                          );
                                        },
                                      )
                                    : const SizedBox(),
                                (userData["job"] == "HRD")
                                    ? MenuTile(
                                        title: 'Daftar Pengajuan Cuti',
                                        icon: Center(
                                          child: FaIcon(
                                            FontAwesomeIcons.listCheck,
                                            color: lightColorScheme.primary,
                                            size: 20,
                                          ),
                                        ),
                                        onTap: () {
                                          Get.toNamed(
                                            Routes.LIST_REQUEST_LEAVE,
                                          );
                                        },
                                      )
                                    : const SizedBox(),
                                MenuTile(
                                  isDanger: true,
                                  title: 'Keluar',
                                  icon: SvgPicture.asset(
                                    'assets/icons/logout.svg',
                                  ),
                                  onTap: controller.logout,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                default:
                  return const SizedBox();
              }
            },
          ),
        );
      },
    );
  }
}
