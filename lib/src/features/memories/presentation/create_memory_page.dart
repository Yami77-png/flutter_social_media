import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/core/utility/app_button.dart';
import 'package:flutter_social_media/src/features/memories/application/create_memories_cubit/create_memories_cubit.dart';
import 'package:flutter_social_media/src/features/memories/presentation/components/memory_privacy_dropdown.dart';
import 'package:flutter_social_media/src/features/memories/presentation/components/time_period_dropdown.dart';

class CreateMemoryPage extends StatefulWidget {
  static const String route = 'create_memory_page';
  const CreateMemoryPage({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<CreateMemoryPage> createState() => _CreateMemoryPageState();
}

class _CreateMemoryPageState extends State<CreateMemoryPage> {
  void _publishMemory() {
    // if (!_canPost) return;

    context.read<CreateMemoriesCubit>().createMemory(
      attachments: [File(widget.imagePath)],
      tags: [],
      privacy: _selectedPrivacy,
      timePeriodInHour: _selectedTimePeriod ?? 24,
    );

    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(NavWrapperPage.route);
    }
  }

  bool _isOptionsVisible = true;
  _toggleOptionsVisible() {
    setState(() {
      _isOptionsVisible = !_isOptionsVisible;
    });
  }

  PostPrivacy _selectedPrivacy = PostPrivacy.PUBLIC;
  int? _selectedTimePeriod;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: _toggleOptionsVisible,
            child: Image.file(
              File(widget.imagePath),
              fit: BoxFit.fitWidth,
              height: double.infinity,
              width: double.infinity,
              errorBuilder: (_, _, _) => Icon(Icons.error_outline_rounded),
            ),
          ),
          AnimatedOpacity(
            duration: Durations.medium1,
            opacity: _isOptionsVisible ? 1 : 0,
            child: _buildOptions(context),
          ),
        ],
      ),
    );
  }

  SafeArea _buildOptions(BuildContext context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: context.pop,
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 1)],
                ),
              ),
              Column(spacing: 16.h, crossAxisAlignment: CrossAxisAlignment.end, children: [
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 6.w,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 1)],
                ),
              ),
              Expanded(
                child: MemoryPrivacyDropdown(
                  value: _selectedPrivacy,
                  onChanged: (val) {
                    setState(() {
                      _selectedPrivacy = val;
                    });
                  },
                ),
              ),
              Expanded(
                child: TimePeriodDropdown(
                  value: _selectedTimePeriod,
                  onChanged: (val) {
                    setState(() {
                      _selectedTimePeriod = val;
                    });
                  },
                ),
              ),
              SizedBox(width: 6.w),
              AppButton(onTap: _publishMemory, label: 'Share'),
            ],
          ),
        ],
      ),
    ),
  );
}
