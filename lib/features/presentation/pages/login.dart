import 'package:blog_app/core/routes/app_routes.dart';
import 'package:blog_app/features/presentation/widgets/auth_gesture_detector.dart';
import 'package:flutter/material.dart';
import '../../../core/text/app_text.dart';
import '../../../core/text/app_text_style.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_gradient_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${AppText.signin}.',
                style: AppTextStyle.heading,
              ),
              const SizedBox(
                height: 30,
              ),
              AuthField(
                controller: _email,
                hintText: AppText.email,
              ),
              const SizedBox(
                height: 15,
              ),
              AuthField(
                isPass: true,
                controller: _password,
                hintText: AppText.password,
              ),
              const SizedBox(
                height: 20,
              ),
              AuthGradientButton(
                onpress: () {},
                title: AppText.signin,
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppText.dontHaveAnAcc,
                    style: AppTextStyle.footerTextStyle,
                  ),
                  AuthGestureDetector(
                    title: AppText.signup,
                    onTapp: () {
                      Navigator.pushNamed(context, AppRoutes.signUpRoute);
                    },
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
