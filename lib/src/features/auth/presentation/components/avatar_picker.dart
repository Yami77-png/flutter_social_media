import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_social_media/l10n/app_localizations.dart';
import 'package:flutter_social_media/src/core/helpers/public_avatar_helper.dart';
import 'package:flutter_social_media/src/core/utility/app_colors.dart';

class AvatarPicker extends StatefulWidget {
  final String gender;
  final Function(String) onAvatarSelected;

  const AvatarPicker({super.key, required this.gender, required this.onAvatarSelected});

  @override
  State<AvatarPicker> createState() => _AvatarPickerState();
}

class _AvatarPickerState extends State<AvatarPicker> {
  String? _selectedAvatar;
  final _avatarHelper = PublicAvatarHelper();

  // Lists of avatars
  final List<String> _maleAvatars = List.generate(10, (i) => 'male_placeholder_${i + 1}');
  final List<String> _femaleAvatars = List.generate(10, (i) => 'female_placeholder_${i + 1}');

  @override
  void initState() {
    super.initState();
    final avatars = widget.gender == 'Male' ? _maleAvatars : _femaleAvatars;
    _selectedAvatar = avatars.isNotEmpty ? avatars.first : null;

    // Notify parent about selection
    if (_selectedAvatar != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onAvatarSelected(_selectedAvatar!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final avatars = widget.gender == 'Male' ? _maleAvatars : _femaleAvatars;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.yourAvatar,
          style: TextStyle(fontSize: 16.sp, fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: avatars.length,
            itemBuilder: (context, index) {
              final avatar = avatars[index];
              final avatarPath = _avatarHelper.getAssetPath(avatar);
              final isSelected = _selectedAvatar == avatar;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAvatar = avatar;
                  });
                  // Pass the selected avatar to the parent widget.
                  widget.onAvatarSelected(avatar);
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: AppColors.primaryColor, width: 3) : null,
                  ),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(radius: 36, backgroundImage: AssetImage(avatarPath)),
                        if (isSelected)
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.black.withAlpha(100)),
                            child: const Icon(Icons.check, color: Colors.white, size: 30),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
