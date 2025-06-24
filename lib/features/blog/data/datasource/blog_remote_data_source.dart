import 'dart:typed_data';
import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:blog_app/features/blog/data/model/reaction_model.dart';
import 'package:blog_app/features/blog/domain/entities/reaction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required Uint8List image,
    required BlogModel blog,
  });
  Future<List<BlogModel>> getAllBlog();
  Future<BlogModel> editBlog({
    required String blogId,
    required String title,
    required String content,
  });
  Future<void> deleteBlog({
    required String blogId,
  });
  Future<List<Reaction>> getReactionsByPostId(
    String postId,
  );
  Future<Reaction> addReaction(
    ReactionModel reaction,
  );
  Future<void> removeReaction(
    String postId,
    String userId,
  );
  Future<Map<ReactionType, int>> getReactionCounts(
    String postId,
  );
  Future<Reaction?> getUserReaction(
    String postId,
    String userId,
  );
}

class BlogRemoteDataSourceImp extends BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImp(this.supabaseClient);
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blocData =
          // To access supabase database we can use client.from("table_name").
          await supabaseClient.from('blogs').insert(blog.toJason()).select();
      return BlogModel.fromJason(blocData.first);
    } catch (e) {
      throw (ServerExceptions(e.toString()));
    }
  }

  @override
  Future<String> uploadBlogImage({
    required Uint8List image,
    required BlogModel blog,
  }) async {
    try {
      // To access supabase storage we can use client.storage.from("container_name").
      await supabaseClient.storage
          .from('blog_images')
          .uploadBinary(blog.id, image);
      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlog() async {
    try {
      // Join operation to get user name from profile table.
      final blogs =
          await supabaseClient.from('blogs').select('*,  profiles(name)');
      return blogs
          .map(
            (blogs) => BlogModel.fromJason(blogs).copyWith(
              posterName: blogs['profiles']['name'],
            ),
          )
          .toList();
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<BlogModel> editBlog({
    required String blogId,
    required String title,
    required String content,
  }) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .update({
            'title': title,
            'content': content,
          })
          .eq('id', blogId)
          .select('*, profiles(name)')
          .single();

      return BlogModel.fromJason(blogData).copyWith(
        posterName: blogData['profiles']['name'],
      );
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<void> deleteBlog({
    required String blogId,
  }) async {
    try {
      final res = await supabaseClient.from('blogs').delete().eq('id', blogId);
      return res;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<Reaction> addReaction(ReactionModel reaction) async {
    try {
      final data = await supabaseClient
          .from('reactions')
          .insert(reaction.toMap())
          .select()
          .single();

      return ReactionModel.fromMap(data);
    } catch (e) {
      print(e.toString());
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<Map<ReactionType, int>> getReactionCounts(String postId) async {
    try {
      final data = await supabaseClient
          .from('reactions')
          .select('type')
          .eq('post_id', postId);

      final Map<ReactionType, int> counts = {};

      for (final row in data) {
        final typeStr = row['type'] as String;
        final type = ReactionType.values.firstWhere(
          (e) => e.name == typeStr,
          orElse: () => ReactionType.like,
        );

        counts[type] = (counts[type] ?? 0) + 1;
      }

      return counts;
    } catch (e) {
      print(e.toString());
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<List<Reaction>> getReactionsByPostId(String postId) async {
    try {
      final data =
          await supabaseClient.from('reactions').select().eq('post_id', postId);

      return data.map<Reaction>((item) => ReactionModel.fromMap(item)).toList();
    } catch (e) {
      print(e.toString());
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<Reaction?> getUserReaction(String postId, String userId) async {
    try {
      final data = await supabaseClient
          .from('reactions')
          .select()
          .eq('post_id', postId)
          .eq('user_id', userId)
          .maybeSingle();

      if (data == null) return null;

      return ReactionModel.fromMap(data);
    } catch (e) {
      print(e.toString());
      throw ServerExceptions(e.toString());
    }
  }

  @override
  Future<void> removeReaction(String postId, String userId) async {
    try {
      await supabaseClient
          .from('reactions')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', userId);
    } catch (e) {
      print(e.toString());
      throw ServerExceptions(e.toString());
    }
  }
}
