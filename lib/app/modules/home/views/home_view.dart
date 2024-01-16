import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/modules/custom_salomon_navbar/controllers/custom_salomon_navbar_controller.dart';
import 'package:hetian_mobile/app/widgets/leave_tile.dart';
import 'package:hetian_mobile/color_schemes.dart';
import 'package:hetian_mobile/app/routes/app_pages.dart';
import 'package:hetian_mobile/app/widgets/leave_card.dart';
import 'package:flutter/services.dart';
import '../controllers/home_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          Get.put(CustomSalomonNavbarController());
          return AnnotatedRegion(
            value: SystemUiOverlayStyle(
              statusBarColor: lightColorScheme.background,
              statusBarIconBrightness: Brightness.dark,
            ),
            child: Scaffold(
              backgroundColor: lightColorScheme.background,
              body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: controller.streamUser(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                    case ConnectionState.done:
                      Map<String, dynamic> user = snapshot.data!.data()!;
                      return SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ListView(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: ClipOval(
                                      child: SizedBox(
                                        width: 48,
                                        height: 48,
                                        child: CachedNetworkImage(
                                          imageUrl: user['avatar'] == null ||
                                                  user['avatar'] == ""
                                              ? "https://ui-avatars.com/api/?name=${user['name']}/"
                                              : user['avatar'],
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const SizedBox(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Hi, Selamat Datang!',
                                    style: TextStyle(
                                      color: Color(0xFF00677C),
                                    ),
                                  ),
                                  Container(
                                    height: 48,
                                    width: 65,
                                    decoration: BoxDecoration(
                                      color: lightColorScheme.primary,
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                        left: Radius.circular(30),
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Get.toNamed(Routes.NOTIFICATIONS);
                                      },
                                      icon: const FaIcon(
                                        FontAwesomeIcons.solidBell,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // section 2 -  card

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: LeaveCard(userData: user),
                              ),

                              // section 3 - history
                              Container(
                                padding: const EdgeInsets.only(
                                    top: 16, bottom: 8, left: 16, right: 16),
                                child: const Text(
                                  "Riwayat Cuti",
                                  style: TextStyle(
                                    fontFamily: "poppins",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: StreamBuilder<
                                    QuerySnapshot<Map<String, dynamic>>>(
                                  stream: controller.streamHistoryLeave(),
                                  builder: (context, snapshot) {
                                    switch (snapshot.connectionState) {
                                      case ConnectionState.waiting:
                                        return const Center(
                                            child: CircularProgressIndicator(
                                          color: Color.fromRGBO(0, 103, 124, 1),
                                        ));
                                      case ConnectionState.active:
                                      case ConnectionState.done:
                                        List<
                                                QueryDocumentSnapshot<
                                                    Map<String, dynamic>>>
                                            listLeave = snapshot.data!.docs;
                                        if (listLeave.isEmpty) {
                                          return const Center(
                                              child: Text(
                                                  'Tidak ada riwayat cuti'));
                                        }
                                        return ListView.separated(
                                          itemCount: listLeave.length,
                                          shrinkWrap: true,
                                          physics:
                                              const ClampingScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(height: 16),
                                          itemBuilder: (context, index) {
                                            Map<String, dynamic> leaveData =
                                                listLeave[index].data();
                                            return LeaveTile(
                                              leaveData: leaveData,
                                            );
                                          },
                                        );
                                      default:
                                        return const SizedBox();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    default:
                      return const Center(child: Text("Error"));
                  }
                },
              ),
            ),
          );
        });
  }
}
