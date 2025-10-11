import 'package:flutter/material.dart';

class CaptionTextField extends StatelessWidget {
  final TextEditingController controller;
  const CaptionTextField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      autofocus: true,
      style: const TextStyle(fontSize: 18, color: Colors.black87),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'What\'s on your mind?',
        hintStyle: TextStyle(fontSize: 20, color: Colors.black38),
      ),
    );
  }
}
