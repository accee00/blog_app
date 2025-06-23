import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/calculate_reading_time.dart';
import 'package:blog_app/core/utils/format_date.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatelessWidget {
  const BlogViewerPage({super.key, required this.blog});
  final Blog blog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section
            Container(
              height: 280,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  blog.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppPallete.greyColor.withOpacity(0.1),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: AppPallete.greyColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Author and Meta Info
                  Row(
                    children: [
                      // Author Avatar (placeholder)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            blog.posterName!.isNotEmpty
                                ? blog.posterName![0].toUpperCase()
                                : 'A',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              blog.posterName!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  formatDate(blog.updatedAt),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        AppPallete.greyColor.withOpacity(0.8),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color:
                                        AppPallete.greyColor.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                Text(
                                  "${calculateReadingTime(blog.content)} min read",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        AppPallete.greyColor.withOpacity(0.8),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Divider
                  Container(
                    height: 1,
                    color: Colors.grey.withOpacity(0.3),
                  ),

                  const SizedBox(height: 32),

                  // Content
                  Text(
                    blog.content,
                    style: const TextStyle(
                      fontSize: 17,
                      height: 1.7,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1,
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
