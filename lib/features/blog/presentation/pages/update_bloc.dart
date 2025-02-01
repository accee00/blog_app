import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor.dart';
import 'package:flutter/material.dart';

class UpdateBloc extends StatefulWidget {
  const UpdateBloc({super.key, required this.blog});
  final Blog blog;

  @override
  State<UpdateBloc> createState() => _UpdateBlocState();
}

class _UpdateBlocState extends State<UpdateBloc> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.blog.title);
    _contentController = TextEditingController(
        text: widget.blog
            .content); // Assuming you want to initialize with content as well
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Blog!"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              Text(
                "You can only Update Blog Title and it's content",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              BlogEditor(
                controller: _titleController,
                hintText: 'Title',
              ),
              BlogEditor(
                controller: _contentController,
                hintText: "Content",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
