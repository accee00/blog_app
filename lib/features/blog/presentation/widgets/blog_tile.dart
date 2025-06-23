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

class _BlogTileState extends State<BlogTile>
    with SingleTickerProviderStateMixin {
  ReactionType defaultReaction = ReactionType.like;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    context.read<ReactionCubit>().loadReactions(widget.blog.id);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
    _navigateToBlogViewer();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  void _navigateToBlogViewer() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BlogViewerPage(blog: widget.blog),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Future<void> toggleReaction() async {
    final cubit = context.read<ReactionCubit>();
    final state = cubit.state;

    if (state is ReactionLoaded) {
      try {
        final userReaction =
            await cubit.getUserReaction(widget.blog.id, widget.userId);

        if (userReaction != null && userReaction.type == defaultReaction) {
          await cubit.removeReaction(widget.blog.id, widget.userId);
        } else {
          await cubit.addReaction(
            Reaction(
              postId: widget.blog.id,
              userId: widget.userId,
              type: defaultReaction,
              createdAt: DateTime.now(),
            ),
          );
        }

        await cubit.loadReactions(widget.blog.id);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update reaction: ${e.toString()}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Blog'),
          content: const Text(
              'Are you sure you want to delete this blog post? This action cannot be undone.'),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context
                    .read<BlogBloc>()
                    .add(BlogDeleteEvent(blogId: widget.blog.id));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final readingTime = calculateReadingTime(widget.blog.content);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color,
                    widget.color.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildTopicChips()),
                              if (widget.isPoster) _buildMenuButton(),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.blog.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.2,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          if (widget.blog.content.isNotEmpty)
                            Text(
                              widget.blog.content,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.9),
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildReadingTime(readingTime),
                              _buildReactionSection(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopicChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: widget.blog.topic.take(3).map((topic) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            topic.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMenuButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: PopupMenuButton<String>(
        icon: const Icon(Icons.more_vert, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
        onSelected: (value) {
          if (value == 'Edit') {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    UpdateBloc(blog: widget.blog),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 200),
              ),
            );
          } else if (value == 'Delete') {
            _showDeleteDialog();
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'Edit',
            child: Row(
              children: [
                Icon(Icons.edit, size: 20),
                SizedBox(width: 12),
                Text('Edit'),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'Delete',
            child: Row(
              children: [
                Icon(Icons.delete, size: 20, color: Colors.red),
                SizedBox(width: 12),
                Text('Delete', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingTime(int readingTime) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            "$readingTime min read",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactionSection() {
    return BlocBuilder<ReactionCubit, ReactionState>(
      builder: (context, state) {
        if (state is ReactionLoading) {
          return const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
        } else if (state is ReactionLoaded) {
          final count = state.counts[defaultReaction] ?? 0;
          return FutureBuilder<Reaction?>(
            future: context
                .read<ReactionCubit>()
                .getUserReaction(widget.blog.id, widget.userId),
            builder: (context, snapshot) {
              final hasReacted = snapshot.data != null &&
                  snapshot.data!.type == defaultReaction;

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: toggleReaction,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              hasReacted
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                              key: ValueKey(hasReacted),
                              size: 18,
                              color: hasReacted ? Colors.yellow : Colors.white,
                            ),
                          ),
                          if (count > 0) ...[
                            const SizedBox(width: 6),
                            Text(
                              count.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is ReactionError) {
          return const Icon(
            Icons.error_outline,
            color: Colors.white70,
            size: 20,
          );
        }
        return const SizedBox();
      },
    );
  }
}
