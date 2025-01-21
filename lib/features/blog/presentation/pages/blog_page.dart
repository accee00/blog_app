import 'package:blog_app/core/routes/app_routes.dart';
import 'package:blog_app/core/text/app_text.dart';
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
      body: Text("data"),
    );
  }
}
