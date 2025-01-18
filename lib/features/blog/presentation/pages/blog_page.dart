import 'package:blog_app/core/routes/app_routes.dart';
import 'package:blog_app/core/text/app_text.dart';
import 'package:blog_app/core/text/app_text_style.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppText.appBarTitle,
        ),
        actions: [
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
      body: Padding(
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
                      height: 20,
                    ),
                    Text(
                      AppText.imgSelect,
                      style: AppTextStyle.footerTextStyle,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
