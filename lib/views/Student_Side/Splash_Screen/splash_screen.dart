import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/Colors/colors.dart';
import '../../../res/assets/image_assets.dart';
import '../../../res/routes/routes_names.dart';
import '../../../services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashServices _splashServices = SplashServices();

  @override
  void initState() {
    super.initState();
    _splashServices.isLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundDark,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColor.surfaceDark.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image.asset(
                    ImageAssets.logo,
                    height: 100,
                    width: 100,
                  ),
                ),
                const SizedBox(height: 24),
                // App Name
                const Text(
                  'TechNation Hub',
                  style: TextStyle(
                    color: AppColor.whiteColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                // Tagline
                Text(
                  'YOUR IT COMMUNITY',
                  style: TextStyle(
                    color: AppColor.whiteColor.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          // Version info at bottom
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.primaryColor.withOpacity(0.1),
                        AppColor.primaryColor,
                        AppColor.primaryColor.withOpacity(0.1),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'v2.4.0-stable',
                  style: TextStyle(
                    color: AppColor.whiteColor.withOpacity(0.5),
                    fontSize: 12,
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
