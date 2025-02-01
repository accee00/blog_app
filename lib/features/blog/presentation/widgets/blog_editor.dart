import 'package:flutter/material.dart';

class BlogEditor extends StatelessWidget {
  const BlogEditor({
    super.key,
    required this.controller,
    required this.hintText,
    this.initval,
  });
  final TextEditingController controller;
  final String hintText;
  final String? initval;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      maxLines: null,
      initialValue: initval,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$hintText is missing";
        }
        return null;
      },
    );
  }
}
