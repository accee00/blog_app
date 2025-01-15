import 'package:blog_app/features/presentation/pages/signup.dart';
import 'package:flutter/material.dart';

import '../../features/presentation/pages/login.dart';

class AppRoutes {
  static const String signUpRoute = '/signup';
  static const String signInRoute = '/signin';
  static Map<String, WidgetBuilder> get routes => {
        signUpRoute: (_) => SignupPage(),
        signInRoute: (_) => LoginPage(),
      };
}
