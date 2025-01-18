import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/entities/user.dart';
import 'package:blog_app/features/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignIn implements Usecase<User, UserSignInParameter> {
  // use AuthRepository to get signup function.
  final AuthRepository authRepository;

  UserSignIn(this.authRepository);

  @override
  Future<Either<Failure, User>> call(UserSignInParameter parameter) async {
    // calling siginFunction...
    return await authRepository.logInWithEmailPassword(
      email: parameter.email,
      password: parameter.password,
    );
  }
}

class UserSignInParameter {
  final String email;
  final String password;

  UserSignInParameter({
    required this.email,
    required this.password,
  });
}
