import 'dart:io';
import 'package:flutter_social_media/src/core/router/app_router_imports.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/posted_by.dart';

abstract class IMemoriesRepository {
  Future<List<Post>> fetchMemories();
  Future<Post?> createMemory({
    required PostedBy postedBy,
    String? caption,
    required List<File> attachments,
    List<String>? tags,
    required PostPrivacy privacy,
    required int timePeriodInHour,
  });
}
