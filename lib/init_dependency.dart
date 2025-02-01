import 'package:blog_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasource/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_imp.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/log_out_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/data/datasource/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/repository/blog_repo_imp.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecases/get_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/update_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependency() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(() => AppUserCubit());
  serviceLocator.registerLazySingleton(
    () => InternetConnectionChecker.createInstance(),
  );

  // Register ConnectionChecker interface with its implementation
  serviceLocator.registerLazySingleton<ConnectionChecker>(
    () => ConnectionCheckerImply(
      serviceLocator(),
    ),
  );
}

/// Initializes the authentication-related dependencies in the service locator.
///
/// This function registers various factories for authentication components
/// such as data sources, repositories, use cases, and BLoC. It ensures that
/// each component can be resolved and injected where needed throughout the
/// application.
void _initAuth() {
  // Register the remote data source for authentication.
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImplementation(
      client: serviceLocator(),
    ),
  );

  // Register the authentication repository.
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImplementation(
      serviceLocator(),
      serviceLocator(),
    ),
  );

  // Register the user sign-up use case.
  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );

  // Register the user sign-in use case.
  serviceLocator.registerFactory(
    () => UserSignIn(
      serviceLocator(),
    ),
  );

  // Register the current user use case.
  serviceLocator.registerFactory(
    () => CurrentUser(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => LogOutUser(
      serviceLocator(),
    ),
  );
  // Register the authentication BLoC.
  serviceLocator.registerFactory(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userSignIn: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
      logOutUser: serviceLocator(),
    ),
  );
}

/// Initializes the blog-related dependencies in the service locator.
///
/// This function registers the following factories:
/// - `BlogRemoteDataSource`: The implementation of the remote data source for blogs.
/// - `BlogRepository`: The implementation of the blog repository.
/// - `UploadBlog`: The use case for uploading a blog, which depends on the blog repository.
/// - `BlogBloc`: The BLoC (Business Logic Component) for managing blog-related state and events.
void _initBlog() {
  // Register remoteData source implementation
  serviceLocator.registerFactory<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImp(
      serviceLocator(),
    ),
  );

  // Register blog repository implementation
  serviceLocator.registerFactory<BlogRepository>(
    () => BlogRepoImp(
      serviceLocator(),
    ),
  );

  // Register use case for uploading a blog
  serviceLocator.registerFactory(
    () => UploadBlog(
      repository: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => GetBlog(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UpdateBlog(
      repository: serviceLocator(),
    ),
  );
  // Register BLoC for blog management
  serviceLocator.registerLazySingleton(
    () => BlogBloc(
      uploadBlog: serviceLocator(),
      getBlog: serviceLocator(),
      updateBlog: serviceLocator(),
    ),
  );
}
