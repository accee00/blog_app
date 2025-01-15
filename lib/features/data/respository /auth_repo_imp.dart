import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/data/datasources/auth_remote_datasource.dart';
import 'package:blog_app/features/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepoImp implements AuthRepository {
  final AuthRemoteDatasource authRemoteDatasource;

  AuthRepoImp(this.authRemoteDatasource);

  @override
  Future<Either<Failure, String>> logInWithEmailPassword(
      {required String email, required String password}) {
    // TODO: implement logInWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> signUpWithEmailPassword(
      {required String email, required String password, required String name}) {
    // try {
    //   final userId = _authRemoteDatasource.signUpWithEmailPassword(
    //     name: name,
    //     email: email,
    //     password: password,
    //   );
    //   return right(userId);
    // } catch (e) {}
    // TODO: implement logInWithEmailPassword
    throw UnimplementedError();
  }
}
