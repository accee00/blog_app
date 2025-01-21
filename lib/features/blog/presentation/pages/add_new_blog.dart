import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../../core/text/app_text.dart';
import '../../../../core/text/app_text_style.dart';
import '../../../../core/theme/app_pallete.dart';

class AddNewBlogPage extends StatefulWidget {
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final TextEditingController _blogTitle = TextEditingController();
  final TextEditingController _blogContent = TextEditingController();
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
              DottedBorder(
                color: AppPallete.borderColor,
                strokeWidth: 2,
                dashPattern: [10, 4],
                radius: Radius.circular(10),
                borderType: BorderType.RRect,
                strokeCap: StrokeCap.round,
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 150,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder_open,
                        size: 40,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppText.imgSelect,
                        style: AppTextStyle.footerTextStyle,
                      )
                    ],
                  ),
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
                          child: Chip(
                            side: BorderSide(
                              color: AppPallete.borderColor,
                            ),
                            label: Text(e),
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
