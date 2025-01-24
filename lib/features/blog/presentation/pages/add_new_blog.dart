import 'dart:io';

import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallete.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final TextEditingController _blogTitle = TextEditingController();
  final TextEditingController _blogContent = TextEditingController();
  List<String> selectedTopic = [];
  File? image;
  void selectImage() async {
    final pickimage = await pickImage();
    if (pickimage != null) {
      setState(() {
        image = pickimage;
      });
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.done_outlined,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  selectImage();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: DottedBorder(
                              color: AppPallete.borderColor,
                              dashPattern: const [10, 4],
                              radius: const Radius.circular(10),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'Select your image',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    'Technology',
                    'Business',
                    'Programming',
                    'Entertainment',
                  ]
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              selectedTopic.contains(e)
                                  ? selectedTopic.remove(e)
                                  : selectedTopic.add(e);
                              // print(selectedTopic);
                              setState(() {});
                            },
                            child: Chip(
                              color: selectedTopic.contains(e)
                                  ? WidgetStatePropertyAll(AppPallete.gradient1)
                                  : null,
                              side: selectedTopic.contains(e)
                                  ? null
                                  : BorderSide(
                                      color: AppPallete.borderColor,
                                    ),
                              label: Text(e),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              BlogEditor(
                controller: _blogTitle,
                hintText: "Blog title",
              ),
              SizedBox(
                height: 20,
              ),
              BlogEditor(
                controller: _blogContent,
                hintText: "Blog content",
              )
            ],
          ),
        ),
      ),
    );
  }
}
