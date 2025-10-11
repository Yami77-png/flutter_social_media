import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/app_snackbar.dart';
import 'package:flutter_social_media/src/features/feed/presentation/create_audio_page.dart';
import 'package:flutter_social_media/src/features/memories/presentation/create_memory_page.dart';

class OptionsFAB extends StatefulWidget {
  const OptionsFAB({super.key});

  @override
  State<OptionsFAB> createState() => _OptionsFABState();
}

class _OptionsFABState extends State<OptionsFAB> {
  double _rotationTurns = 0.0;

  Future<void> _pickMemoriesImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null && context.mounted) {
        context.pushNamed(CreateMemoryPage.route, extra: pickedFile.path);
      } else {
        //
      }
    } catch (e) {
      log('Pick image error: $e');
      AppSnackbar.show(context, message: 'Failed to pick image.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: AppColors.primaryColor,
      activeBackgroundColor: AppColors.primaryColor,
      activeForegroundColor: AppColors.primaryColor,
      spacing: 8,
      spaceBetweenChildren: 8,
      children: [
        SpeedDialChild(
          onTap: () => _pickMemoriesImage(context),
          shape: CircleBorder(),
          child: Icon(Icons.image_outlined, color: AppColors.primaryColor),
          label: 'Story',
        ),
        SpeedDialChild(
          onTap: () => context.pushNamed(CreateAudioPage.route),
          shape: CircleBorder(),
          child: Icon(Icons.mic, color: AppColors.primaryColor),
          label: 'Voice',
        ),
        SpeedDialChild(
          onTap: () => context.pushNamed(CreatePostPage.route),
          shape: CircleBorder(),
          child: Icon(Icons.create, color: AppColors.primaryColor),
          label: 'Post',
        ),
      ],

      onOpen: () {
        setState(() {
          _rotationTurns = 0.125;
        });
      },
      onClose: () {
        setState(() {
          _rotationTurns = 0.0;
        });
      },
      child: AnimatedRotation(
        duration: Duration(seconds: 1),
        turns: _rotationTurns,
        child: Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
