import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/assets.dart';
import 'package:flutter_social_media/src/features/Profile/presentation/component/profile_picture_blob_clipper.dart';

// ProfilePicBlob widget to use ClipPath
class ProfilePicBlob extends StatelessWidget {
  ProfilePicBlob({super.key, required this.profilePicUrl, this.profilePicFile, this.size = 60});

  final String? profilePicUrl;
  final File? profilePicFile;
  final double size;

  static const _placeholderPath = Assets.malePlaceholder1Png;

  // Image Loading Logic
  Future<Uint8List> _loadBytesFromAsset(String path) async {
    final byteData = await rootBundle.load(path);
    return byteData.buffer.asUint8List();
  }

  Future<Uint8List> _loadBytesFromNetwork(String url) async {
    final file = await DefaultCacheManager().getSingleFile(url);
    return await file.readAsBytes();
  }

  Future<Uint8List> _loadProfileImageBytes() async {
    if (profilePicFile != null) {
      try {
        return await profilePicFile!.readAsBytes();
      } catch (e) {
        log("Failed to load local file bytes: $e");
        return await _loadBytesFromAsset(_placeholderPath);
      }
    }

    if (profilePicUrl == null || profilePicUrl!.trim().isEmpty) {
      return await _loadBytesFromAsset(_placeholderPath);
    }

    final trimmed = profilePicUrl!.trim();
    if (trimmed.startsWith('assets/')) {
      return await _loadBytesFromAsset(trimmed);
    }

    final uri = Uri.tryParse(trimmed);
    if (uri != null && uri.hasScheme && uri.host.isNotEmpty) {
      try {
        return await _loadBytesFromNetwork(trimmed);
      } catch (e) {
        log("Failed to load network image: $e. Falling back to placeholder.");
      }
    }

    return await _loadBytesFromAsset(_placeholderPath);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _loadProfileImageBytes(),
      builder: (context, snapshot) {
        // Image Loading Indicator
        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
          return SizedBox(
            width: size,
            height: size,
            child: Center(
              child: SizedBox(
                width: size * 0.4,
                height: size * 0.4,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          // Show error in image box, if failed to load
          return SizedBox(
            width: size,
            height: size,
            child: Icon(Icons.error_outline, color: AppColors.primaryColor),
          );
        }

        final profileImageBytes = snapshot.data!;

        return ClipPath(
          clipper: ProfilePictureBlobClipper(),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              // The light gray background color.
              color: AppColors.grayLight,
              // The profile image, drawn on top of the background.
              image: DecorationImage(image: MemoryImage(profileImageBytes), fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }
}
