import 'dart:developer';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/post.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_thumbnail/video_thumbnail.dart';

class Helpers {
  static String getTimeAgo(String postedAt, {bool isShort = false}) {
    try {
      final postTime = DateTime.parse(postedAt);
      return timeago.format(postTime, allowFromNow: false, locale: isShort ? 'en_short' : 'en');
    } catch (e) {
      return 'just now';
    }
  }

  static Future<void> sharePost(Post post) async {
    SharePlus.instance.share(
      ShareParams(text: "Check out this post: https://example.com/post_details_page/${post.id}"),
    );
  }

  static Future<String?> generateThumbnail(String videoUrl, String postId) async {
    final tempDir = await getTemporaryDirectory();
    final postFolder = Directory('${tempDir.path}/posts/videos/$postId');

    if (!postFolder.existsSync()) {
      postFolder.createSync(recursive: true);
    }

    final customThumbnailPath = '${postFolder.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      thumbnailPath: customThumbnailPath,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 250,
      quality: 100,
    );

    log('Generated thumbnail at: $thumbnailPath');
    return thumbnailPath;
  }

  String formatDate(String dateString) {
    try {
      final DateTime dateTime = DateTime.parse(dateString);
      final int day = dateTime.day;

      //st, nd, rd, th for days
      final String ordinalSuffix = _getOrdinalSuffix(day);

      final String monthYear = DateFormat('MMM y').format(dateTime);

      return '$day$ordinalSuffix $monthYear';
    } catch (e) {
      print('Error parsing date string: $e');
      return dateString;
    }
  }

  int calculateAge(String dateString) {
    try {
      final DateTime dob = DateTime.parse(dateString);
      final DateTime today = DateTime.now();

      int age = today.year - dob.year;

      if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
        age--;
      }

      return age;
    } catch (e) {
      print('Error parsing date string for age calculation: $e');
      return 0;
    }
  }

  String _getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
