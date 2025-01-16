import 'package:blog_app/core/routes/app_routes.dart';
import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/features/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/presentation/pages/signup.dart';
import 'package:blog_app/init_dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await initDependency();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<AuthBloc>(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Blog App",
      theme: AppTheme.themeData,
      routes: AppRoutes.routes,
      home: SignupPage(),
    );
  }
}
