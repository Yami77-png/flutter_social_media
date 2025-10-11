import 'package:flutter/material.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';
import 'package:flutter_social_media/src/core/utility/assets.dart';
import 'package:flutter_social_media/src/features/feed/domain/models/post.dart';

class PrivacyDropdown extends StatelessWidget {
  final PostPrivacy value;
  final ValueChanged<PostPrivacy?> onChanged;
  final bool isDark;
  const PrivacyDropdown({required this.value, required this.onChanged, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    _getPrivacyIcon(PostPrivacy privacy) {
      switch (privacy) {
        case PostPrivacy.PUBLIC:
          return Icons.public_rounded;
        case PostPrivacy.FRIENDS:
          return Icons.people_outline_outlined;
        case PostPrivacy.ONLYME:
          return Icons.lock_outline_rounded;
      }
    }

    _getPrivacyName(PostPrivacy privacy) {
      switch (privacy) {
        case PostPrivacy.PUBLIC:
          return "Public";
        case PostPrivacy.FRIENDS:
          return "Friends";
        case PostPrivacy.ONLYME:
          return "Only Me";
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 0),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.22) : AppColors.gray200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<PostPrivacy>(
          padding: EdgeInsets.all(0),
          value: value,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          icon: Icon(Icons.keyboard_arrow_down_outlined, size: 24, color: isDark ? Colors.white : Colors.black87),
          dropdownColor: isDark ? Colors.black87 : Colors.white,
          items: PostPrivacy.values.map((PostPrivacy privacy) {
            return DropdownMenuItem<PostPrivacy>(
              value: privacy,
              child: Row(
                children: [
                  Icon(_getPrivacyIcon(privacy)),
                  const SizedBox(width: 6),
                  Text(
                    _getPrivacyName(privacy),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w200,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
