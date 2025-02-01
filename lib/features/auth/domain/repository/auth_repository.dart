import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  // Either if it is a success return User
  // if failure return Failuer
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> logInWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, Unit>> logOutCurrentUser();
}
