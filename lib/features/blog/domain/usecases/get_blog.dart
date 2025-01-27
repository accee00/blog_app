import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetBlog implements Usecase<List<Blog>, Noparams> {
  final BlogRepository blogRepository;
  GetBlog(this.blogRepository);
  @override
  Future<Either<Failure, List<Blog>>> call(Noparams parameter) async {
    return await blogRepository.getAllBlog();
  }
}
