import 'dart:io';
import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/blog/data/datasource/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepoImp implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  BlogRepoImp(this.blogRemoteDataSource);
  @override
  Future<Either<Failure, BlogModel>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topic: topics,
        updatedAt: DateTime.now(),
      );
      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );
      blogModel = blogModel.copyWith(imageUrl: imageUrl);
      final uploadedBloc = await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedBloc);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<BlogModel>>> getAllBlog() async {
    try {
      final blogs = await blogRemoteDataSource.getAllBlog();
      return right(blogs);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, BlogModel>> updateBlog({
    required String blogId,
    required String title,
    required String content,
  }) async {
    try {
      final blog = await blogRemoteDataSource.editBlog(
          blogId: blogId, title: title, content: content);
      return right(blog);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteBlog({required String blogId}) async {
    try {
      await blogRemoteDataSource.deleteBlog(blogId: blogId);
      return right(unit);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure("Failed to delete blog"));
    }
  }
}
