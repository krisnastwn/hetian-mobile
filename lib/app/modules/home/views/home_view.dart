import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hetian_mobile/app/modules/custom_salomon_navbar/controllers/custom_salomon_navbar_controller.dart';
import 'package:hetian_mobile/app/widgets/leave_tile.dart';
import 'package:hetian_mobile/color_schemes.dart';
import 'package:hetian_mobile/app/routes/app_pages.dart';
import 'package:hetian_mobile/app/widgets/leave_card.dart';
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
        return Scaffold(
          body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> user = snapshot.data!.data()!;
                return Scaffold(
                  appBar: AppBar(
                    elevation: 0,
                    scrolledUnderElevation: 0,
                    title: Text(
                      'Hi, Selamat Datang!\n${user['name']}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color.fromRGBO(0, 103, 124, 1),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    actions: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: CachedNetworkImageProvider(
                          user['avatar'] == null || user['avatar'] == ""
                              ? "https://ui-avatars.com/api/?name=${user['name']}&size=512/"
                              : user['avatar'],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 48,
                        width: 65,
                        decoration: BoxDecoration(
                          color: lightColorScheme.primary,
                          borderRadius: const BorderRadius.horizontal(
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
                  body: Padding(
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // section 1 - leave
                        LeaveCard(userData: user),

                        const Padding(
                          padding: EdgeInsets.only(top: 16, bottom: 8),
                          child: Text(
                            "Riwayat Cuti",
                            style: TextStyle(
                              fontFamily: "poppins",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        // section 2 - history
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: controller.streamHistoryLeave(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Color.fromRGBO(0, 103, 124, 1),
                                ),
                              );
                            } else if (snapshot.connectionState ==
                                    ConnectionState.active ||
                                snapshot.connectionState ==
                                    ConnectionState.done) {
                              List<QueryDocumentSnapshot<Map<String, dynamic>>>
                                  listLeave = snapshot.data!.docs;
                              if (listLeave.isEmpty) {
                                return const Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Text(
                                          "Tidak ada riwayat cuti",
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Expanded(
                                child: ListView.separated(
                                  itemCount: listLeave.length,
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 16),
                                  itemBuilder: (context, index) {
                                    QueryDocumentSnapshot<Map<String, dynamic>>
                                        doc = listLeave[index];
                                    Map<String, dynamic> leaveData = doc.data();
                                    leaveData['doc_id'] = doc.id;
                                    return LeaveTile(
                                      leaveData: leaveData,
                                    );
                                  },
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromRGBO(0, 103, 124, 1),
                  ),
                );
              } else {
                return const Center(child: Text("Error"));
              }
            },
          ),
        );
      },
    );
  }
}
