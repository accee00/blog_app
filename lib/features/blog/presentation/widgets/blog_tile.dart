import 'package:blog_app/features/blog/presentation/pages/update_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/calculate_reading_time.dart';
import '../../domain/entities/blog.dart';
import '../pages/blog_viewer_page.dart';

class BlogTile extends StatelessWidget {
  const BlogTile({
    super.key,
    required this.isPoster,
    required this.color,
    required this.blog,
  });
  final Blog blog;
  final Color color;
  final bool isPoster;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlogViewerPage(blog: blog),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(15).copyWith(
          bottom: 8,
        ),
        padding: const EdgeInsets.all(15),
        height: 200,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: blog.topic
                              .map(
                                (e) => Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Chip(
                                    label: Text(
                                      e.toString(),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    if (isPoster)
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert),
                        onSelected: (value) {
                          // Handle the selected option
                          if (value == 'Edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateBloc(
                                  blog: blog,
                                ),
                              ),
                            );
                          } else if (value == 'Delete') {
                            // Delete blog action
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return {'Edit', 'Delete'}.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                  ],
                ),
                Text(
                  blog.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              "${calculateReadingTime(blog.content)} min",
            ),
          ],
        ),
      ),
    );
  }
}
