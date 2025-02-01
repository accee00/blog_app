import 'dart:io';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements Usecase<Blog, UploadBlogParams> {
  final BlogRepository repository;
  UploadBlog({
    required this.repository,
  });

  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams parameter) async {
    return repository.uploadBlog(
      image: parameter.image,
      title: parameter.title,
      content: parameter.content,
      posterId: parameter.posterId,
      topics: parameter.topics,
    );
  }
}

class UploadBlogParams {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}
