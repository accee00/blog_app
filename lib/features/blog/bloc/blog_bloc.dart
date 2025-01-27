import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadBlog;
  final GetBlog getBlog;
  BlogBloc({
    required this.getBlog,
    required this.uploadBlog,
  }) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });
    on<BlogUploadEvent>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
  }
  void _onBlogUpload(BlogUploadEvent event, Emitter<BlogState> emit) async {
    final result = await uploadBlog.call(
      UploadBlogParams(
          posterId: event.posterId,
          title: event.title,
          content: event.content,
          image: event.image,
          topics: event.topics),
    );
    result.fold(
      (l) => emit(
        BlogFailure(l.message),
      ),
      (s) => emit(
        BlogSuccess(),
      ),
    );
  }

  void _onFetchAllBlogs(
    BlogFetchAllBlogs event,
    Emitter<BlogState> emit,
  ) async {
    final res = await getBlog.call(Noparams());
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (s) => emit(
        BlogDisplaySucess(s),
      ),
    );
  }
}
