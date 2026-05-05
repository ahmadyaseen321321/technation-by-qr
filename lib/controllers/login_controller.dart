import 'package:get/get.dart';

class LoginController extends GetxController {
  final emailController = RxString('');
  final passwordController = RxString('');
  final obscurePassword = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void login() {
    // Static login for now
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.offAllNamed('/home');
    });
  }
}
