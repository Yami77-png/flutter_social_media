import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileAvatarWithAddButton extends StatefulWidget {
  final double size;

  const ProfileAvatarWithAddButton({super.key, this.size = 160.0});

  @override
  State<ProfileAvatarWithAddButton> createState() => _ProfileAvatarWithAddButtonState();
}

class _ProfileAvatarWithAddButtonState extends State<ProfileAvatarWithAddButton> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: widget.size / 2,
          backgroundColor: Colors.grey.shade100,
          backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
          child: _imageFile == null ? Icon(Icons.person, size: widget.size * 0.5, color: Colors.grey.shade400) : null,
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: widget.size * 0.25,
              height: widget.size * 0.25,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(Icons.add, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
