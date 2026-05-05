import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/login_controller.dart';
import '../../../res/Colors/colors.dart';
import '../../../res/assets/image_assets.dart';
import '../../../res/routes/routes_names.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Custom Header
            Container(
              padding: const EdgeInsets.only(top: 60, bottom: 20, left: 24, right: 24),
              color: AppColor.backgroundDark,
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  const Text(
                    'TechNation Hub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 4,
                shadowColor: Colors.black12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Logo Icon
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Image.asset(ImageAssets.logo, height: 40, width: 40),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColor.blackColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your credentials to access the hub',
                        style: TextStyle(color: AppColor.greyColor),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      
                      // Email Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email Address',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            onChanged: (v) => controller.emailController.value = v,
                            decoration: InputDecoration(
                              hintText: 'name@company.com',
                              hintStyle: TextStyle(color: AppColor.greyColor.withOpacity(0.5)),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColor.lightGreyColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColor.lightGreyColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Password Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Password',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () => Get.toNamed(RouteName.forgotPasswordScreen),
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(color: AppColor.primaryColor, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Obx(() => TextField(
                            onChanged: (v) => controller.passwordController.value = v,
                            obscureText: controller.obscurePassword.value,
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.obscurePassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  color: AppColor.greyColor,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColor.lightGreyColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: AppColor.lightGreyColor),
                              ),
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Login Button
                      Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value ? null : controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primaryColor,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 8,
                          shadowColor: AppColor.primaryColor.withOpacity(0.4),
                        ),
                        child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.login_rounded, color: Colors.white),
                              ],
                            ),
                      )),
                      const SizedBox(height: 32),
                      
                      // Or Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: AppColor.lightGreyColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text('or continue with', style: TextStyle(color: AppColor.greyColor, fontSize: 12)),
                          ),
                          Expanded(child: Divider(color: AppColor.lightGreyColor)),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Social Logins
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.g_mobiledata, color: AppColor.googleRed, size: 30),
                              label: const Text('Google', style: TextStyle(color: Colors.black87)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                side: const BorderSide(color: AppColor.lightGreyColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.code, color: AppColor.githubBlack),
                              label: const Text('GitHub', style: TextStyle(color: Colors.black87)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                side: const BorderSide(color: AppColor.lightGreyColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      // Footer Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('New here? '),
                          GestureDetector(
                            onTap: () => Get.toNamed(RouteName.registerScreen),
                            child: const Text(
                              'Join free',
                              style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Info
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Placeholder icons for professional images
                      const Align(
                        widthFactor: 0.6,
                        child: CircleAvatar(radius: 12, backgroundColor: Colors.blueGrey),
                      ),
                      const Align(
                        widthFactor: 0.6,
                        child: CircleAvatar(radius: 12, backgroundColor: Colors.indigo),
                      ),
                      const CircleAvatar(radius: 12, backgroundColor: Colors.teal),
                      const SizedBox(width: 8),
                      Text(
                        'Join 12,000+ elite IT professionals today.',
                        style: TextStyle(color: AppColor.greyColor, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBadge('#TECHCOUNCIL'),
                      const SizedBox(width: 8),
                      _buildBadge('BETA 2.4'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColor.primaryColor, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}
