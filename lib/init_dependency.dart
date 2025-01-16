import 'package:blog_app/features/data/datasource/auth_remote_data_source.dart';
import 'package:blog_app/features/data/repository/auth_repository_imp.dart';
import 'package:blog_app/features/domain/repository/auth_repository.dart';
import 'package:blog_app/features/domain/usecases/user_sign_up.dart';
import 'package:blog_app/features/presentation/bloc/auth_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;
Future<void> initDependency() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
}

// initialize auth dependency!
void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImplementation(
      client: serviceLocator(),
    ),
  );
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImplementation(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );
  serviceLocator.registerFactory(
    () => AuthBloc(
      userSignUp: serviceLocator(),
    ),
  );
}
