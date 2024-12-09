import 'package:get/get.dart';

import '../screens/sa_login_screen.dart';

class ProjectRouter {
  static const SA_LOGIN_SCREEN = '/login-screen';

  static var routes = [
    GetPage(
        name: SA_LOGIN_SCREEN,
        page: () => SaLoginScreen(),
        transition: Transition.rightToLeftWithFade),
  ];
}
