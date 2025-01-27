import 'package:blog_app/core/routes/app_routes.dart';
import 'package:blog_app/core/text/app_text.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/bloc/blog_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppText.appBarTitle,
          ),
          actions: [
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthInitial) {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.signInRoute, (route) => false);
                }
              },
              builder: (context, state) {
                return IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogOutCurrentUser());
                  },
                  icon: Icon(Icons.logout_outlined),
                );
              },
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.addBloc);
              },
              icon: Icon(
                CupertinoIcons.add_circled,
              ),
            ),
          ],
        ),
        body: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              showSnackbar(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is BlogDisplaySucess) {
              return ListView.builder(
                itemCount: state.blog.length,
                itemBuilder: (context, index) {
                  final blog = state.blog[index];
                  return Text(
                    blog.title,
                  );
                },
              );
            }
            return SizedBox();
          },
        ));
  }
}
