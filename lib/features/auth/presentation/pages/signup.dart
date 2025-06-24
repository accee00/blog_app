import 'package:blog_app/core/text/app_text.dart';
import 'package:blog_app/core/text/app_text_style.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_field.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gesture_detector.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';

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
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              showSnackbar(context, 'Login to continue.');
              Navigator.pushNamed(context, AppRoutes.signInRoute);
            }
            if (state is AuthFailure) {
              showSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Form(
              key: formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${AppText.signup}. ",
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
                    AuthGradientButton(
                      onpress: () {
                        if (formKey.currentState!.validate()) {
                          context.read<AuthBloc>().add(
                                AuthSignUp(
                                  name: _name.text.trim(),
                                  password: _passwordcontroller.text.trim(),
                                  email: _emailcontroller.text.trim(),
                                ),
                              );
                        }
                      },
                      title: AppText.signup,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppText.alreadyHaveAnAcc,
                          style: AppTextStyle.footerTextStyle,
                        ),
                        AuthGestureDetector(
                          title: AppText.signin,
                          onTapp: () {
                            Navigator.pushNamed(context, AppRoutes.signInRoute);
                          },
                        ),
                      ],
                    ),
                  ]),
            );
          },
        ),
      ),
    );
  }
}
