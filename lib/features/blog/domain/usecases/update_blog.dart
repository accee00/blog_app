import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateBlog implements Usecase<Blog, UpdateBlogParams> {
  final BlogRepository repository;

  UpdateBlog({required this.repository});
  @override
  Future<Either<Failure, Blog>> call(UpdateBlogParams parameter) {
    return repository.updateBlog(
        blogId: parameter.blogId,
        title: parameter.title,
        content: parameter.content);
  }
}

class UpdateBlogParams {
  final String blogId;
  final String title;
  final String content;

  UpdateBlogParams({
    required this.blogId,
    required this.title,
    required this.content,
  });
}
