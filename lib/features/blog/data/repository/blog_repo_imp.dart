import 'dart:io';
import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/blog/data/datasource/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:blog_app/features/blog/data/model/reaction_model.dart';
import 'package:blog_app/features/blog/domain/entities/reaction.dart';
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
        blogId: blogId,
        title: title,
        content: content,
      );
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

  @override
  Future<Either<Failure, Reaction>> addReaction(Reaction reaction) async {
    try {
      final existing = await blogRemoteDataSource.getUserReaction(
        reaction.postId,
        reaction.userId,
      );

      if (existing != null && existing.type == reaction.type) {
        // 2. Toggle OFF → remove reaction
        await blogRemoteDataSource.removeReaction(
          reaction.postId,
          reaction.userId,
        );
        return left(Failure('Reaction removed'));
      } else {
        final newReaction = await blogRemoteDataSource.addReaction(
          ReactionModel(
            postId: reaction.postId,
            userId: reaction.userId,
            type: reaction.type,
            createdAt: DateTime.now(),
          ),
        );
        return right(newReaction);
      }
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure("Unexpected error: $e"));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeReaction(
    String postId,
    String userId,
  ) async {
    try {
      await blogRemoteDataSource.removeReaction(postId, userId);
      return right(unit);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Reaction>>> getReactionsByPostId(
    String postId,
  ) async {
    try {
      final reactions = await blogRemoteDataSource.getReactionsByPostId(postId);
      return right(reactions);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Map<ReactionType, int>>> getReactionCounts(
      String postId) async {
    try {
      final counts = await blogRemoteDataSource.getReactionCounts(postId);
      return right(counts);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, Reaction?>> getUserReaction(
    String postId,
    String userId,
  ) async {
    try {
      final reaction =
          await blogRemoteDataSource.getUserReaction(postId, userId);
      return right(reaction);
    } on ServerExceptions catch (e) {
      return left(Failure(e.message));
    }
  }
}
