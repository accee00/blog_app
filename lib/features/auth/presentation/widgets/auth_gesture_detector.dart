import 'package:flutter/material.dart';

import '../../../../core/text/app_text_style.dart';
import '../../../../core/theme/app_pallete.dart';

class AuthGestureDetector extends StatelessWidget {
  const AuthGestureDetector(
      {super.key, required this.title, required this.onTapp});
  final String title;
  final VoidCallback onTapp;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapp,
      child: Text(
        title,
        style: AppTextStyle.footerTextStyle.copyWith(
          color: AppPallete.gradient2,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
