import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../repository/blog_repository.dart';

class DeleteBlog implements Usecase<void, DeleteBlogParams> {
  final BlogRepository repository;

  DeleteBlog({required this.repository});

  @override
  Future<Either<Failure, void>> call(DeleteBlogParams parameter) async {
    return await repository.deleteBlog(blogId: parameter.blogId);
  }
}

class DeleteBlogParams {
  final String blogId;

  DeleteBlogParams({
    required this.blogId,
  });
}
