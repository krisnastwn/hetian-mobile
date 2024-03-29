import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hetian_mobile/app/modules/navigation_bar/controllers/navigation_bar_controller.dart';
import 'package:hetian_mobile/color_schemes.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        return GetMaterialApp(
          initialBinding: BindingsBuilder(() {
            Get.put(NavigationBarController());
          }),
          title: "Application",
          debugShowCheckedModeBanner: false,
          initialRoute:
              snapshot.data != null ? Routes.NAVIGATION_BAR : Routes.LOGIN,
          getPages: AppPages.routes,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: lightColorScheme,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'inter',
          ),
        );
      },
    ),
  );
}
