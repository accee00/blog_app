import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/domain/entities/user.dart';
import 'package:blog_app/features/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements Usecase<User, UserSignupParameter> {
  // use AuthRepository to get signup function.
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignupParameter parameter) async {
    // calling sigup Function...
    return await authRepository.signUpWithEmailPassword(
        name: parameter.name,
        email: parameter.email,
        password: parameter.password);
  }
}

class UserSignupParameter {
  final String name;
  final String email;
  final String password;

  UserSignupParameter({
    required this.name,
    required this.email,
    required this.password,
  });
}
