import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:blog_app/features/auth/domain/usecases/current_user.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/update_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/material.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadBlog;
  final GetBlog getBlog;
  final UpdateBlog updateBlog;
  final DeleteBlog deleteBlog;
  BlogBloc({
    required this.updateBlog,
    required this.getBlog,
    required this.uploadBlog,
    required this.deleteBlog,
  }) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });
    on<BlogUploadEvent>(_onBlogUpload);
    on<BlogFetchAllBlogs>(_onFetchAllBlogs);
    on<BlogUpdateEvent>(_updateBlog);
    on<BlogDeleteEvent>(_deleteBlog);
  }

  FutureOr<void> _deleteBlog(event, emit) async {
    final res = await deleteBlog.call(DeleteBlogParams(blogId: event.blogId));
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (_) => emit(BlogSuccess()),
    );
  }

  FutureOr<void> _updateBlog(event, emit) async {
    final res = await updateBlog.call(UpdateBlogParams(
        blogId: event.blogId, title: event.title, content: event.content));
    res.fold(
      (l) => emit(BlogFailure(l.message)),
      (s) {
        emit(BlogSuccess());
        add(BlogFetchAllBlogs());
      },
    );
  }

  void _onBlogUpload(BlogUploadEvent event, Emitter<BlogState> emit) async {
    final result = await uploadBlog.call(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
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
