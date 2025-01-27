import 'package:blog_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/routes/app_routes.dart';
import 'package:blog_app/core/theme/theme.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/pages/login.dart';
import 'package:blog_app/features/blog/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
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
      BlocProvider<AppUserCubit>(
        create: (_) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider<AuthBloc>(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
      BlocProvider<BlogBloc>(
        create: (_) => serviceLocator<BlogBloc>(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Blog App",
      theme: AppTheme.themeData,
      routes: AppRoutes.routes,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) => state is AppUserLoggedIn,
        builder: (context, state) {
          if (state is! AppUserLoggedIn) {
            return BlogPage();
          }
          return LoginPage();
        },
      ),
    );
  }
}
