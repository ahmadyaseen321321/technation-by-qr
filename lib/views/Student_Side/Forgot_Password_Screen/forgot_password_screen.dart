import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/Colors/colors.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back, color: AppColor.primaryColor, size: 18),
                    SizedBox(width: 8),
                    Text('Back to Login', style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    // Illustration Placeholder
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.mark_email_read_outlined, size: 80, color: AppColor.primaryColor),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      'Reset Password',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColor.blackColor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enter your email and we\'ll send you a reset link.',
                      style: TextStyle(color: AppColor.greyColor),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    
                    // Email Field
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColor.lightGreyColor),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          icon: Icon(Icons.email_outlined, color: AppColor.greyColor),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Button
                    ElevatedButton(
                      onPressed: () {
                        Get.snackbar('Success', 'Reset link sent to your email');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Send Reset Link', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Remembered your password? '),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
