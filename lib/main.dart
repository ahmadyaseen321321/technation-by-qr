import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technation_hub/res/Colors/colors.dart';
import 'res/routes/routes.dart';
import 'res/routes/routes_names.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'TechNation Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColor.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primaryColor,
          primary: AppColor.primaryColor,
          secondary: AppColor.secondaryColor,
          surface: AppColor.surfaceLight,
          background: AppColor.backgroundLight,
        ),
        scaffoldBackgroundColor: AppColor.backgroundLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColor.backgroundDark,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialRoute: RouteName.splashScreen,
      getPages: AppRoute.approutes(),
    );
  }
}
