import 'package:get/get.dart';

import '../screens/sa_login_screen.dart';
import '../screens/staff/staff_home_screen.dart';
import '../screens/super_admin/sa_home_screen.dart';

class ProjectRouter {
  static const SA_LOGIN_SCREEN = '/login-screen';
  static const SA_HOME_SCREEN = '/home-screen';
  static const STAFF_HOME_SCREEN = '/staff-screen';
  static var routes = [
    //SA_LOGIN_SCREEN
    GetPage(
        name: SA_LOGIN_SCREEN,
        page: () => SaLoginScreen(),
        transition: Transition.rightToLeftWithFade),

    //SA_HOME_SCREEN
    GetPage(
        name: SA_HOME_SCREEN,
        page: () => SaHomeScreen(),
        transition: Transition.circularReveal),

    GetPage(
        name: STAFF_HOME_SCREEN,
        page: () => StaffHomeScreen(),
        transition: Transition.circularReveal)
  ];
}
