import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/entities/reaction.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:blog_app/features/blog/presentation/pages/update_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/features/blog/presentation/cubit/reaction_cubit.dart';

class BlogTile extends StatefulWidget {
  const BlogTile({
    super.key,
    required this.isPoster,
    required this.color,
    required this.blog,
    required this.userId,
  });

  final Blog blog;
  final Color color;
  final bool isPoster;
  final String userId;

  @override
  State<BlogTile> createState() => _BlogTileState();
}

class _BlogTileState extends State<BlogTile> {
  ReactionType defaultReaction = ReactionType.like;

  @override
  void initState() {
    super.initState();
    context.read<ReactionCubit>().loadReactions(widget.blog.id);
  }

  void toggleReaction() async {
    final cubit = context.read<ReactionCubit>();
    final state = cubit.state;

    if (state is ReactionLoaded) {
      final userReaction =
          await cubit.getUserReaction(widget.blog.id, widget.userId);

      if (userReaction != null && userReaction.type == defaultReaction) {
        await cubit.removeReaction(widget.blog.id, widget.userId);
      } else {
        await cubit.addReaction(
          Reaction(
            id: '', // let Supabase auto-generate
            postId: widget.blog.id,
            userId: widget.userId,
            type: defaultReaction,
            createdAt: DateTime.now(),
          ),
        );
      }

      // Refresh the state
      await cubit.loadReactions(widget.blog.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlogViewerPage(blog: widget.blog),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(15).copyWith(bottom: 8),
        padding: const EdgeInsets.all(15),
        height: 240,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: widget.blog.topic
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Chip(label: Text(e.toString())),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    if (widget.isPoster)
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'Edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UpdateBloc(blog: widget.blog),
                              ),
                            );
                          } else if (value == 'Delete') {
                            context.read<BlogBloc>().add(
                                  BlogDeleteEvent(blogId: widget.blog.id),
                                );
                          }
                        },
                        itemBuilder: (context) => ['Edit', 'Delete']
                            .map((e) => PopupMenuItem(value: e, child: Text(e)))
                            .toList(),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  widget.blog.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${calculateReadingTime(widget.blog.content)} min"),
                Row(
                  children: [
                    BlocBuilder<ReactionCubit, ReactionState>(
                      builder: (context, state) {
                        if (state is ReactionLoading) {
                          return const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        } else if (state is ReactionLoaded) {
                          final count = state.counts[defaultReaction] ?? 0;
                          return Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_up_alt_outlined),
                                onPressed: toggleReaction,
                              ),
                              Text('$count'),
                            ],
                          );
                        } else if (state is ReactionError) {
                          return const Text("Error");
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
