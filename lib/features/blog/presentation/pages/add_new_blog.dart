import 'dart:typed_data';
import 'package:blog_app/core/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/routes/app_routes.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_pallete.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final TextEditingController _blogTitle = TextEditingController();
  final TextEditingController _blogContent = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  List<String> selectedTopic = [];
  Uint8List? image;

  void selectImage() async {
    final pickimage = await pickImage();
    if (pickimage != null) {
      setState(() {
        image = pickimage;
      });
    }
  }

  void uploadBlog() {
    if (formkey.currentState!.validate()) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      if (image == null) {
        showSnackbar(context, 'Image for blog is required');
        return;
      }
      if (selectedTopic.isEmpty) {
        showSnackbar(context, 'Please select at least one topic');
        return;
      }
      context.read<BlogBloc>().add(
            BlogUploadEvent(
              posterId: posterId,
              title: _blogTitle.text.trim(),
              content: _blogContent.text.trim(),
              image: image!,
              topics: selectedTopic,
            ),
          );
    }
  }

  @override
  void dispose() {
    _blogTitle.dispose();
    _blogContent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Create Blog',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: uploadBlog,
              icon: const Icon(
                Icons.publish_rounded,
                size: 20,
              ),
              label: const Text(
                'Publish',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppPallete.gradient1.withOpacity(0.1),
                foregroundColor: AppPallete.gradient1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          } else if (state is BlogSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.blogPage,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Publishing your blog...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          return Form(
            key: formkey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Upload Section
                    const Text(
                      'Cover Image',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: selectImage,
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: image != null
                            ? Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.memory(
                                      image!, // <-- fix here
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : DottedBorder(
                                // ignore: deprecated_member_use
                                color: Colors.grey.withOpacity(0.5),
                                dashPattern: const [8, 4],
                                radius: const Radius.circular(16),
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                strokeWidth: 2,
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.grey.withOpacity(0.05),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppPallete.gradient1
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        child: Icon(
                                          Icons.add_photo_alternate_outlined,
                                          size: 32,
                                          color: AppPallete.gradient1,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        'Add Cover Image',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Tap to select an image',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Topics Section
                    const Text(
                      'Select Topics',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Technology',
                        'Business',
                        'Programming',
                        'Entertainment',
                      ].map((topic) {
                        final isSelected = selectedTopic.contains(topic);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedTopic.remove(topic);
                              } else {
                                selectedTopic.add(topic);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppPallete.gradient1
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppPallete.gradient1
                                    : Colors.grey.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              topic,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSelected ? Colors.white : null,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 32),

                    // Title Section
                    const Text(
                      'Blog Title',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    BlogEditor(
                      controller: _blogTitle,
                      hintText: "Enter an engaging title for your blog...",
                    ),

                    const SizedBox(height: 32),

                    // Content Section
                    const Text(
                      'Blog Content',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    BlogEditor(
                      controller: _blogContent,
                      hintText: "Write your blog content here...",
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
