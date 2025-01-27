import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:fpdart/fpdart.dart';

class LogOutUser implements Usecase<void, Noparams> {
  final AuthRepository authRepository;
  LogOutUser(this.authRepository);
  @override
  Future<Either<Failure, void>> call(Noparams parameter) async {
    return await authRepository.logOutCurrentUser();
  }
}
