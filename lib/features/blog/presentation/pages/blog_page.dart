import 'package:blog_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/routes/app_routes.dart';
import 'package:blog_app/core/text/app_text.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/cubit/reaction_cubit.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_tile.dart';
import 'package:blog_app/init_dependency.dart';
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
            BlocBuilder<AuthBloc, AuthState>(
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
              final posterId =
                  (context.read<AppUserCubit>().state as AppUserLoggedIn)
                      .user
                      .id;
              return state.blog.isEmpty
                  ? Center(
                      child: Text(
                        'Nothing to display. Try adding blogs',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: state.blog.length,
                      itemBuilder: (context, index) {
                        final blog = state.blog[index];
                        final userId =
                            (context.read<AuthBloc>().state as AuthSuccess)
                                .user
                                .id;

                        return BlocProvider(
                          create: (_) => serviceLocator<ReactionCubit>()
                            ..loadReactions(blog.id),
                          child: BlogTile(
                            isPoster: blog.posterId == posterId,
                            color: index % 3 == 0
                                ? AppPallete.gradient1
                                : index % 3 == 1
                                    ? AppPallete.gradient2
                                    : AppPallete.gradient3,
                            blog: blog,
                            userId: userId,
                          ),
                        );
                      },
                    );
            }
            return SizedBox();
          },
        ));
  }
}
