
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:technation_hub/Models/user_model.dart';
import 'package:technation_hub/User_Prefrences/User_Prefrecnes.dart';
import 'package:technation_hub/repositories/auth_repository.dart';
import 'package:technation_hub/utils/utils.dart';

class LoginController extends GetxController {
  final _api = AuthRepository();
  final _userPreference = UserPreferences();

  final emailController = RxString('');
  final passwordController = RxString('');
  final obscurePassword = true.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void login() {
    if (emailController.value.isEmpty || passwordController.value.isEmpty) {
      Utils.snackbar('Error', 'Please fill all fields');
      return;
    }

    isLoading.value = true;

    Map data = {
      'email': emailController.value,
      'password': passwordController.value,
    };

    _api.loginApi(data).then((value) {
      isLoading.value = false;
      
      if (value['success'] == true) {
        UserModel userModel = UserModel.fromJson(value);
        _userPreference.saveUser(userModel).then((_) {
          Utils.snackbar('Success', 'Login Successful');
          Get.offAllNamed('/home');
        });
      } else {
        Utils.snackbar('Error', value['error'] ?? 'Login Failed');
      }
    }).onError((error, stackTrace) {
      isLoading.value = false;
      if (kDebugMode) {
        print(error.toString());
      }
      Utils.snackbar('Error', error.toString());
    });
  }
}
