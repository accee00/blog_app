import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
}

class BlogRemoteDataSourceImp extends BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImp(this.supabaseClient);
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blocData =
          await supabaseClient.from('blogs').insert(blog.toJason()).select();
      return BlogModel.fromJason(blocData.first);
    } catch (e) {
      throw (ServerExceptions(e.toString()));
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage.from('blog_images').upload(blog.id, image);
      return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
