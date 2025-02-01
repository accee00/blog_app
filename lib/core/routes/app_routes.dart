import 'package:blog_app/features/auth/presentation/pages/signup.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:flutter/material.dart';

import '../../features/auth/presentation/pages/login.dart';

class AppRoutes {
  static const String signUpRoute = '/signup';
  static const String signInRoute = '/signin';
  static const String blogPage = '/blogpage';
  static const String addBloc = '/addblog';
  static const String viewBloc = '/viewblog';
  static Map<String, WidgetBuilder> get routes => {
        signUpRoute: (_) => const SignupPage(),
        signInRoute: (_) => const LoginPage(),
        blogPage: (_) => const BlogPage(),
        addBloc: (_) => const AddNewBlogPage(),
      };
}
