import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/features/presentation/pages/signup.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Blog App",
      theme: AppTheme.themeData,
      home: SignupPage(),
    );
  }
}
