import 'package:blog_app/core/text/app_text.dart';
import 'package:blog_app/core/text/app_text_style.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _name.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
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
                AppText.signup,
                style: AppTextStyle.heading,
              ),
              const SizedBox(
                height: 30,
              ),
              AuthField(
                controller: _name,
                hintText: AppText.name,
              ),
              const SizedBox(
                height: 15,
              ),
              AuthField(
                controller: _emailcontroller,
                hintText: AppText.email,
              ),
              const SizedBox(
                height: 15,
              ),
              AuthField(
                isPass: true,
                controller: _passwordcontroller,
                hintText: AppText.password,
              ),
              const SizedBox(
                height: 20,
              ),
              AuthGradientButton(),
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
                  Text(
                    AppText.signin,
                    style: AppTextStyle.footerTextStyle.copyWith(
                      color: AppPallete.gradient2,
                      fontWeight: FontWeight.bold,
                    ),
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
