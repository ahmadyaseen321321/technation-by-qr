import 'package:get/get.dart';
import 'package:technation_hub/res/routes/routes_names.dart';
import 'package:technation_hub/views/Student_Side/Splash_Screen/splash_screen.dart';
import 'package:technation_hub/views/Student_Side/Onboarding_Screen/onboarding_screen.dart';
import 'package:technation_hub/views/Student_Side/Login_Screen/login_screen.dart';
import 'package:technation_hub/views/Student_Side/Registration_Screen/registration_screen.dart';
import 'package:technation_hub/views/Student_Side/Forgot_Password_Screen/forgot_password_screen.dart';
import 'package:technation_hub/views/Student_Side/main_screen.dart';
import 'package:technation_hub/views/Student_Side/Chat_Screen/chat_screen.dart';
import 'package:technation_hub/views/Student_Side/Notification_Screen/notification_screen.dart';
import 'package:technation_hub/views/Student_Side/AI_Screen/ai_screen.dart';

class AppRoute {
  static approutes() => [
        GetPage(
          name: RouteName.splashScreen,
          page: () => const SplashScreen(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: RouteName.onboardingScreen,
          page: () => const OnboardingScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.loginScreen,
          page: () => LoginScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.registerScreen,
          page: () => const RegistrationScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.forgotPasswordScreen,
          page: () => const ForgotPasswordScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.homeScreen,
          page: () => const MainScreen(),
          transition: Transition.zoom,
        ),
        GetPage(
          name: RouteName.chatScreen,
          page: () => const ChatScreen(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: RouteName.notificationScreen,
          page: () => const NotificationScreen(),
          transition: Transition.downToUp,
        ),
        GetPage(
          name: RouteName.aiScreen,
          page: () => const OpenClawScreen(),
          transition: Transition.rightToLeft,
        ),
      ];
}
